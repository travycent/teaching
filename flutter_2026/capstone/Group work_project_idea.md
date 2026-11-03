
#GROUP MEMBERS
LUBEGA SHAWUTHABU 241_21301_7381
AYUGI FAITH 241_22302_7231
NAJJINGO FAIZAH 241_22302_7021
# Integrated Maternal and Child Health Monitoring System
## Project Idea
A system that brings maternal and child health records into one database so health workers can monitor mothers and children, track visits and immunizations, and catch risks early.

## What It Does
- Registers mothers, children, and health workers
- Records antenatal and postnatal visits
- Tracks child immunizations and growth (weight, height)
- Sends reminders for upcoming and missed appointments
- Flags high-risk cases (e.g. high blood pressure, underweight child)
- Generates reports for health facilities

## Database Tables

### users table (Master Table)
| Field | Type | Description |
|-------|------|-------------|
| user_id (PK) | INT | Unique ID |
| full_name | VARCHAR | Full name |
| email | VARCHAR | Login email |
| phone | VARCHAR | Contact number |
| password | VARCHAR | Hashed password |
| role | VARCHAR | Mother, Health Worker, or Admin |
| created_at | DATETIME | Date registered |

### mothers table
| Field | Type | Description |
|-------|------|-------------|
| mother_id (PK) | INT | Unique ID |
| user_id (FK) | INT | Links to users |
| date_of_birth | DATE | Date of birth |
| address | VARCHAR | Home address |
| expected_delivery_date | DATE | Due date |

### children table
| Field | Type | Description |
|-------|------|-------------|
| child_id (PK) | INT | Unique ID |
| mother_id (FK) | INT | Links to mothers |
| name | VARCHAR | Child's name |
| date_of_birth | DATE | Date of birth |
| gender | VARCHAR | Gender |

### antenatal_visits table
| Field | Type | Description |
|-------|------|-------------|
| visit_id (PK) | INT | Unique ID |
| mother_id (FK) | INT | Links to mothers |
| health_worker_id (FK) | INT | Links to users |
| visit_date | DATE | Date of visit |
| blood_pressure | VARCHAR | BP reading |
| weight | DECIMAL | Weight in kg |
| notes | TEXT | Observations |

### immunizations table
| Field | Type | Description |
|-------|------|-------------|
| immunization_id (PK) | INT | Unique ID |
| child_id (FK) | INT | Links to children |
| vaccine_name | VARCHAR | Vaccine given |
| date_given | DATE | Date given |
| next_due_date | DATE | Next dose date |

### growth_records table
| Field | Type | Description |
|-------|------|-------------|
| record_id (PK) | INT | Unique ID |
| child_id (FK) | INT | Links to children |
| record_date | DATE | Date measured |
| weight | DECIMAL | Weight in kg |
| height | DECIMAL | Height in cm |

### appointments table
| Field | Type | Description |
|-------|------|-------------|
| appointment_id (PK) | INT | Unique ID |
| user_id (FK) | INT | Links to users |
| appointment_date | DATETIME | Scheduled time |
| status | VARCHAR | Pending, Attended, Missed |
PK -PRIMARY KEY
FK -FOREIGN KEY 
