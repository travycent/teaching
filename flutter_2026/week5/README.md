# Week 5: An API with a Database (FastAPI + SQLite)

By the end of today you can build an API that stores its data in a database, so nothing is lost when the server restarts.

Next class: login (register, log in, and protect the API with a token).

**Class recording:** [watch on YouTube](https://www.youtube.com/watch?v=9NHZzcuZV7A)

## Setup

Check your Python version first with `python3 --version`. Python 3.9 or newer works.

```bash
mkdir noticeboard_api && cd noticeboard_api
python -m venv venv
source venv/bin/activate          # Windows: venv\Scripts\activate
pip install "fastapi[standard]" sqlmodel
```

To run the class code from this repository instead, use the pinned versions:

```bash
cd flutter_2026/week5
python -m venv venv
source venv/bin/activate          # Windows: venv\Scripts\activate
pip install -r requirements.txt
```

Create a `.gitignore` containing:

```
venv/
__pycache__/
*.db
```

## Run

```bash
fastapi dev main.py
```

- API: http://127.0.0.1:8000
- Interactive docs: http://127.0.0.1:8000/docs

The first run creates a file called `noticeboard.db` next to `main.py`. That file is your database.

## Endpoints

| Method | Path | What it does | Success code |
| --- | --- | --- | --- |
| GET | `/` | Check the API is running | 200 |
| GET | `/notices` | List all notices, newest first | 200 |
| POST | `/notices` | Create a notice | 201 |
| GET | `/notices/{id}` | Get one notice | 200 |
| PUT | `/notices/{id}` | Update a notice | 200 |
| DELETE | `/notices/{id}` | Delete a notice | 204 |

Errors: **404** when the notice does not exist, **422** when the request body is missing a required field.

## The idea in one picture

```
Flutter app  --JSON over HTTP-->  FastAPI  --SQL-->  SQLite (noticeboard.db)
```

`NoticeCreate` is what the app may send. `Notice` is the database table: the same fields plus an `id` and `created_at` that the server adds.

## Try it

1. Create three notices with POST in `/docs`, then GET the list
2. Edit one with PUT and delete one
3. Ask for `/notices/99` and see the 404
4. Send a POST without a `title` and see the 422
5. Stop the server and start it again: **the notices are still there**
6. Open `noticeboard.db` in DB Browser for SQLite (or the SQLite extension in VS Code) and look at the `notice` table

## Open it from a phone

```bash
fastapi dev main.py --host 0.0.0.0
```

Put the phone on the same Wi-Fi as the laptop and open `http://<laptop-ip>:8000/notices` in the phone's browser.
Find the laptop's IP with `ipconfig` (Windows) or `ifconfig` (Mac/Linux).

## Common problems

- `fastapi: command not found`: the virtual environment is not activated
- `No module named sqlmodel`: run `pip install sqlmodel` inside the activated environment
- Port already in use: an old server is still running
- 422 on POST: the JSON is missing a required field
- You added or changed a column and get a database error: tables are only created if they do not exist, so they are never altered. Stop the server, delete `noticeboard.db`, and start again. (Real projects use migrations for this.)

## Homework

Create `backend/main.py` in your group repository: an API with a database for the **main entity of your own project**, with full GET, POST, PUT and DELETE. Commit and push it. Do not commit the `.db` file.
