from datetime import datetime, timedelta, timezone
from typing import Annotated, List, Optional

import bcrypt
import jwt
from fastapi import Depends, FastAPI, HTTPException
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from sqlalchemy import event
from sqlalchemy.exc import IntegrityError
from sqlmodel import Field, Session, SQLModel, create_engine, select

SECRET_KEY = "change-this-secret-in-real-projects"
ALGORITHM = "HS256"
TOKEN_MINUTES = 120

engine = create_engine(
    "sqlite:///noticeboard.db", connect_args={"check_same_thread": False}
)


# SQLite only enforces foreign keys if we switch it on for every connection
@event.listens_for(engine, "connect")
def enable_foreign_keys(dbapi_connection, connection_record):
    cursor = dbapi_connection.cursor()
    cursor.execute("PRAGMA foreign_keys=ON")
    cursor.close()


# ---------- Tables ----------
class User(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    username: str = Field(unique=True, index=True)
    password_hash: str  # we never store the real password


class Category(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    name: str


class Notice(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    title: str
    message: str
    category_id: int = Field(foreign_key="category.id")
    author_id: int = Field(foreign_key="user.id")  # who posted it
    created_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))


# ---------- Shapes the app sends and receives (not tables) ----------
class UserCreate(SQLModel):
    username: str
    password: str


class NoticeCreate(SQLModel):
    title: str
    message: str
    category_id: int


class NoticeRead(SQLModel):
    id: int
    title: str
    message: str
    category_id: int
    author_id: int
    author_name: str
    created_at: datetime


def to_read(notice: Notice, author: User) -> NoticeRead:
    return NoticeRead(
        id=notice.id,
        title=notice.title,
        message=notice.message,
        category_id=notice.category_id,
        author_id=notice.author_id,
        author_name=author.username,
        created_at=notice.created_at,
    )


SQLModel.metadata.create_all(engine)

# Add a few default categories the first time the server runs
with Session(engine) as seed_session:
    if seed_session.exec(select(Category)).first() is None:
        for name in ["General", "Events", "Lost and found"]:
            seed_session.add(Category(name=name))
        seed_session.commit()

app = FastAPI(title="Campus Noticeboard API")


def get_session():
    with Session(engine) as session:
        yield session


SessionDep = Annotated[Session, Depends(get_session)]


# ---------- Passwords and tokens ----------
def hash_password(password: str) -> str:
    return bcrypt.hashpw(password.encode(), bcrypt.gensalt()).decode()


def verify_password(password: str, password_hash: str) -> bool:
    return bcrypt.checkpw(password.encode(), password_hash.encode())


def create_token(user_id: int) -> str:
    expires = datetime.now(timezone.utc) + timedelta(minutes=TOKEN_MINUTES)
    return jwt.encode(
        {"sub": str(user_id), "exp": expires}, SECRET_KEY, algorithm=ALGORITHM
    )


oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")


# Runs before every protected endpoint: reads the token, finds the user
def get_current_user(
    token: Annotated[str, Depends(oauth2_scheme)], session: SessionDep
) -> User:
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        user_id = int(payload["sub"])
    except (jwt.PyJWTError, KeyError, ValueError):
        raise HTTPException(
            status_code=401,
            detail="Invalid or expired token",
            headers={"WWW-Authenticate": "Bearer"},
        )
    user = session.get(User, user_id)
    if user is None:
        raise HTTPException(status_code=401, detail="User not found")
    return user


CurrentUser = Annotated[User, Depends(get_current_user)]


# ---------- Open endpoints ----------
@app.get("/")
def home():
    return {"message": "Noticeboard API is running"}


@app.post("/register", status_code=201)
def register(data: UserCreate, session: SessionDep):
    username = data.username.strip()
    if len(username) < 3:
        raise HTTPException(status_code=400, detail="Username must be at least 3 characters")
    if not 4 <= len(data.password) <= 50:
        raise HTTPException(status_code=400, detail="Password must be 4 to 50 characters")
    taken = session.exec(select(User).where(User.username == username)).first()
    if taken:
        raise HTTPException(status_code=400, detail="Username already taken")
    user = User(username=username, password_hash=hash_password(data.password))
    session.add(user)
    session.commit()
    session.refresh(user)
    return {"id": user.id, "username": user.username}


@app.post("/login")
def login(form: Annotated[OAuth2PasswordRequestForm, Depends()], session: SessionDep):
    user = session.exec(select(User).where(User.username == form.username)).first()
    if user is None or not verify_password(form.password, user.password_hash):
        raise HTTPException(status_code=401, detail="Wrong username or password")
    return {
        "access_token": create_token(user.id),
        "token_type": "bearer",
        "user_id": user.id,
        "username": user.username,
    }


# ---------- Protected endpoints (login required) ----------
@app.get("/categories")
def list_categories(session: SessionDep, current_user: CurrentUser):
    return session.exec(select(Category)).all()


@app.get("/notices", response_model=List[NoticeRead])
def list_notices(session: SessionDep, current_user: CurrentUser):
    rows = session.exec(
        select(Notice, User)
        .where(Notice.author_id == User.id)
        .order_by(Notice.created_at.desc())
    ).all()
    return [to_read(notice, author) for notice, author in rows]


@app.post("/notices", status_code=201, response_model=NoticeRead)
def create_notice(data: NoticeCreate, session: SessionDep, current_user: CurrentUser):
    notice = Notice(
        title=data.title,
        message=data.message,
        category_id=data.category_id,
        author_id=current_user.id,
    )
    session.add(notice)
    try:
        session.commit()
    except IntegrityError:
        session.rollback()
        raise HTTPException(status_code=400, detail="That category does not exist")
    session.refresh(notice)
    return to_read(notice, current_user)


@app.put("/notices/{notice_id}", response_model=NoticeRead)
def update_notice(
    notice_id: int, data: NoticeCreate, session: SessionDep, current_user: CurrentUser
):
    notice = session.get(Notice, notice_id)
    if notice is None:
        raise HTTPException(status_code=404, detail="Notice not found")
    if notice.author_id != current_user.id:
        raise HTTPException(status_code=403, detail="You can only edit your own notices")
    notice.title = data.title
    notice.message = data.message
    notice.category_id = data.category_id
    session.add(notice)
    try:
        session.commit()
    except IntegrityError:
        session.rollback()
        raise HTTPException(status_code=400, detail="That category does not exist")
    session.refresh(notice)
    return to_read(notice, current_user)


@app.delete("/notices/{notice_id}", status_code=204)
def delete_notice(notice_id: int, session: SessionDep, current_user: CurrentUser):
    notice = session.get(Notice, notice_id)
    if notice is None:
        raise HTTPException(status_code=404, detail="Notice not found")
    if notice.author_id != current_user.id:
        raise HTTPException(status_code=403, detail="You can only delete your own notices")
    session.delete(notice)
    session.commit()
