from datetime import datetime, timezone
from typing import Annotated, Optional

from fastapi import Depends, FastAPI, HTTPException
from sqlmodel import Field, Session, SQLModel, create_engine, select

# The database is a single file called noticeboard.db, created next to main.py
engine = create_engine(
    "sqlite:///noticeboard.db", connect_args={"check_same_thread": False}
)


# What the app sends when creating or updating a notice
class NoticeCreate(SQLModel):
    title: str
    message: str
    category: str = "general"


# The table: the same fields plus an id and a timestamp the server adds
class Notice(NoticeCreate, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    created_at: datetime = Field(default_factory=lambda: datetime.now(timezone.utc))


# Create the tables if they do not exist yet
SQLModel.metadata.create_all(engine)

app = FastAPI(title="Campus Noticeboard API")


# Gives each request its own database session, and closes it afterwards
def get_session():
    with Session(engine) as session:
        yield session


SessionDep = Annotated[Session, Depends(get_session)]


@app.get("/")
def home():
    return {"message": "Noticeboard API is running"}


@app.get("/notices")
def list_notices(session: SessionDep):
    return session.exec(select(Notice).order_by(Notice.created_at.desc())).all()


@app.post("/notices", status_code=201)
def create_notice(data: NoticeCreate, session: SessionDep):
    notice = Notice.model_validate(data)
    session.add(notice)
    session.commit()
    session.refresh(notice)
    return notice


@app.get("/notices/{notice_id}")
def get_notice(notice_id: int, session: SessionDep):
    notice = session.get(Notice, notice_id)
    if notice is None:
        raise HTTPException(status_code=404, detail="Notice not found")
    return notice


@app.put("/notices/{notice_id}")
def update_notice(notice_id: int, data: NoticeCreate, session: SessionDep):
    notice = session.get(Notice, notice_id)
    if notice is None:
        raise HTTPException(status_code=404, detail="Notice not found")
    notice.title = data.title
    notice.message = data.message
    notice.category = data.category
    session.add(notice)
    session.commit()
    session.refresh(notice)
    return notice


@app.delete("/notices/{notice_id}", status_code=204)
def delete_notice(notice_id: int, session: SessionDep):
    notice = session.get(Notice, notice_id)
    if notice is None:
        raise HTTPException(status_code=404, detail="Notice not found")
    session.delete(notice)
    session.commit()
