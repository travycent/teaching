# Week 6: Login and Protected Endpoints (FastAPI + JWT)

By the end of today your API knows **who** is using it: people register, log in, get a token, and can only edit or delete their own notices.

This builds on the [week 5 noticeboard API](../week5/README.md).

## Setup

```bash
cd flutter_2026/week6
python -m venv venv
source venv/bin/activate          # Windows: venv\Scripts\activate
pip install -r requirements.txt
```

Starting from your own week 5 project instead? Add the two new packages:

```bash
pip install bcrypt PyJWT
```

## Run

```bash
fastapi dev main.py
```

- API: http://127.0.0.1:8000
- Interactive docs: http://127.0.0.1:8000/docs

The tables changed since week 5, so if you are reusing an old `noticeboard.db`, **delete it first**. The first run creates a fresh one with three categories: General, Events, Lost and found.

## What changed since week 5

| Week 5 | Week 6 |
| --- | --- |
| Anyone can do anything | You must log in to use `/notices` and `/categories` |
| `category` is free text | `category_id` points to a row in the new `category` table |
| A notice has no owner | A notice has an `author_id`, and the API returns `author_name` |
| Anyone can edit or delete | Only the author can edit or delete their notice |

## Endpoints

| Method | Path | Login needed | What it does | Success code |
| --- | --- | --- | --- | --- |
| GET | `/` | No | Check the API is running | 200 |
| POST | `/register` | No | Create an account | 201 |
| POST | `/login` | No | Get a token | 200 |
| GET | `/categories` | Yes | List categories | 200 |
| GET | `/notices` | Yes | List all notices, newest first | 200 |
| POST | `/notices` | Yes | Create a notice (you become the author) | 201 |
| PUT | `/notices/{id}` | Yes, author only | Update a notice | 200 |
| DELETE | `/notices/{id}` | Yes, author only | Delete a notice | 204 |

Errors:

- **400**: username taken, username shorter than 3 characters, password not 4 to 50 characters, or a `category_id` that does not exist
- **401**: no token, a wrong or expired token, or a wrong username or password at login
- **403**: you are trying to edit or delete someone else's notice
- **404**: the notice does not exist

## The idea in one picture

```
1. POST /register   {username, password}   -> account created (password stored as a bcrypt hash)
2. POST /login      username + password    -> {access_token, ...}
3. GET  /notices    Authorization: Bearer <access_token>   -> the notices
```

- **Hashing (bcrypt):** we never store the real password, only a hash. At login we hash what was typed and compare.
- **Token (JWT):** a signed string that says "this is user 5" and expires after 120 minutes. The app sends it with every request in the `Authorization` header.
- **`get_current_user`:** a dependency that runs before every protected endpoint. It reads the token, finds the user, and returns 401 if anything is wrong.

`/login` takes **form data** (`username` and `password` fields), not JSON. That is the OAuth2 standard, and it is what makes the **Authorize** button in `/docs` work.

## Try it

1. In `/docs`, register two users, for example `amy` and `bob`
2. Try GET `/notices` without logging in and see the 401
3. Click **Authorize** (top right), log in as `amy`, then GET `/categories`
4. Create a notice with `category_id: 1` and check that `author_name` is `amy`
5. Create a notice with `category_id: 99` and see the 400
6. Log out, authorize as `bob`, and try to delete amy's notice: see the 403
7. Open `noticeboard.db` and look at the `user` table: the passwords are hashes, not the real passwords

## Calling it from Flutter

```dart
// Log in: send form data, keep the token
final res = await http.post(
  Uri.parse('$baseUrl/login'),
  body: {'username': username, 'password': password},
);
final token = jsonDecode(res.body)['access_token'];

// Every protected request: add the header
final notices = await http.get(
  Uri.parse('$baseUrl/notices'),
  headers: {'Authorization': 'Bearer $token'},
);
```

## Common problems

- `No module named bcrypt` or `No module named jwt`: run `pip install -r requirements.txt` inside the activated environment
- A database error about a missing column such as `author_id`: you have an old `noticeboard.db` from week 5. Stop the server, delete it, and start again
- 401 on every request in `/docs`: click **Authorize** first. Tokens expire after 120 minutes, so log in again
- 422 at `/login`: you sent JSON. Login expects form fields

## Security note

`SECRET_KEY` is written in `main.py` so the class code runs as-is. In a real project, keep it out of the code (for example in an environment variable) and make it long and random. Anyone who knows it can make valid tokens.

## Homework

Add register, login, and protected endpoints to the `backend/main.py` in your group repository. Each row of your main entity should have an owner, and only the owner may edit or delete it. Commit and push. Do not commit the `.db` file.
