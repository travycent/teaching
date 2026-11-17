import hashlib
from datetime import date
from typing import Annotated, Optional


from fastapi import Depends, FastAPI, HTTPException
from sqlmodel import Field, Session, SQLModel, create_engine, select


# The database is a single file called maternal.db, created next to main.py
engine = create_engine(
    "sqlite:///maternal.db", connect_args={"check_same_thread": False}
)


ROLES = ["mother", "worker", "admin"]

# ---------- USERS (master table) ----------


class UserBase(SQLModel):
    name: str
    phone: str = Field(unique=True)
    role: str = "mother"  # mother / worker / admin
class UserCreate(UserBase):
    password: str
class User(UserBase, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    password: str  # stored hashed
class UserRead(UserBase):
    id: int

# ---------- MOTHERS ----------

class MotherCreate(SQLModel):
    user_id: int = Field(foreign_key="user.id")
    dob: Optional[date] = None
    village: str = ""
    due_date: Optional[date] = None
class Mother(MotherCreate, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)


# ---------- CHILDREN ----------


class ChildCreate(SQLModel):
    mother_id: int = Field(foreign_key="mother.id")
    name: str
    dob: date
    sex: str = ""
    birth_weight: Optional[float] = None
class Child(ChildCreate, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)


# ---------- VISITS ----------

class VisitCreate(SQLModel):
    mother_id: int = Field(foreign_key="mother.id")
    child_id: Optional[int] = Field(default=None, foreign_key="child.id")
    health_worker_id: int = Field(foreign_key="user.id")
    visit_date: date
    weight: Optional[float] = None
    bp: str = ""  # e.g. 120/80
    notes: str = ""
class Visit(VisitCreate, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)

# ---------- VACCINATIONS ----------

class VaccinationCreate(SQLModel):
    child_id: int = Field(foreign_key="child.id")
    vaccine: str
    date_due: date
    date_given: Optional[date] = None
    status: str = "Pending"  # Pending / Given / Missed
class Vaccination(VaccinationCreate, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)

# ---------- APPOINTMENTS ----------

class AppointmentCreate(SQLModel):
    mother_id: int = Field(foreign_key="mother.id")
    appt_date: date
    type: str = "Antenatal"
    status: str = "Pending"  # Pending / Attended / Missed
class Appointment(AppointmentCreate, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)

# ---------- REMINDERS ----------

class ReminderCreate(SQLModel):
    user_id: int = Field(foreign_key="user.id")
    message: str
    send_date: date
    sent: bool = False
class Reminder(ReminderCreate, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
# Create the tables if they do not exist yet
SQLModel.metadata.create_all(engine)
app = FastAPI(title="Maternal and Child Health API")

# Gives each request its own database session, and closes it afterwards


def get_session():
    with Session(engine) as session:
        yield session
SessionDep = Annotated[Session, Depends(get_session)]
def hash_password(password: str) -> str:
    return hashlib.sha256(password.encode()).hexdigest()
@app.get("/")
def home():
    return {"message": "Maternal and Child Health API is running"}


# =============== USERS ===============


@app.get("/users", response_model=list[UserRead])
def list_users(session: SessionDep):
    return session.exec(select(User)).all()
@app.post("/users", status_code=201, response_model=UserRead)
def create_user(data: UserCreate, session: SessionDep):
    if data.role not in ROLES:
        raise HTTPException(status_code=400, detail="Role must be mother, worker or admin")
    if session.exec(select(User).where(User.phone == data.phone)).first():
        raise HTTPException(status_code=400, detail="Phone already registered")
    user = User(
        name=data.name,
        phone=data.phone,
        role=data.role,
        password=hash_password(data.password),
    )
    session.add(user)
    session.commit()
    session.refresh(user)
    return user
@app.get("/users/{user_id}", response_model=UserRead)
def get_user(user_id: int, session: SessionDep):
    user = session.get(User, user_id)
    if user is None:
        raise HTTPException(status_code=404, detail="User not found")
    return user
@app.put("/users/{user_id}", response_model=UserRead)
def update_user(user_id: int, data: UserBase, session: SessionDep):
    user = session.get(User, user_id)
    if user is None:
        raise HTTPException(status_code=404, detail="User not found")
    if data.role not in ROLES:
        raise HTTPException(status_code=400, detail="Role must be mother, worker or admin")
    user.name = data.name
    user.phone = data.phone
    user.role = data.role
    session.add(user)
    session.commit()
    session.refresh(user)
    return user
@app.delete("/users/{user_id}", status_code=204)
def delete_user(user_id: int, session: SessionDep):
    user = session.get(User, user_id)
    if user is None:
        raise HTTPException(status_code=404, detail="User not found")
    session.delete(user)
    session.commit()
# =============== THE OTHER TABLES ===============


# One helper builds GET (list), POST, GET (one), PUT and DELETE for a table


def add_crud(path: str, Table, CreateModel):
    @app.get(f"/{path}", name=f"list_{path}")
    def list_items(session: SessionDep):
        return session.exec(select(Table)).all()
    @app.post(f"/{path}", status_code=201, name=f"create_{path}")
    def create_item(data: CreateModel, session: SessionDep):
        item = Table.model_validate(data)
        session.add(item)
        session.commit()
        session.refresh(item)
        return item
    @app.get(f"/{path}/{{item_id}}", name=f"get_{path}")
    def get_item(item_id: int, session: SessionDep):
        item = session.get(Table, item_id)
        if item is None:
            raise HTTPException(status_code=404, detail="Not found")
        return item
    @app.put(f"/{path}/{{item_id}}", name=f"update_{path}")
    def update_item(item_id: int, data: CreateModel, session: SessionDep):
        item = session.get(Table, item_id)
        if item is None:
            raise HTTPException(status_code=404, detail="Not found")
        for field, value in data.model_dump().items():
            setattr(item, field, value)
        session.add(item)
        session.commit()
        session.refresh(item)
        return item
    @app.delete(f"/{path}/{{item_id}}", status_code=204, name=f"delete_{path}")
    def delete_item(item_id: int, session: SessionDep):
        item = session.get(Table, item_id)
        if item is None:
            raise HTTPException(status_code=404, detail="Not found")
        session.delete(item)
        session.commit()
add_crud("mothers", Mother, MotherCreate)
add_crud("children", Child, ChildCreate)
add_crud("visits", Visit, VisitCreate)
add_crud("vaccinations", Vaccination, VaccinationCreate)
add_crud("appointments", Appointment, AppointmentCreate)
add_crud("reminders", Reminder, ReminderCreate)