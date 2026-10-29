# Deogiri College Smart Attendance System

A Flask web application for managing class attendance with role-based access, signed QR codes, and location verification. A student scans a session QR code; the server checks the token, verifies the student is within 100 meters of the session location, and rejects duplicate check-ins.

## Live Application

- Student dashboard: https://smart-attendance-lj9c.onrender.com/student/dashboard
- Administrator login: https://smart-attendance-lj9c.onrender.com/auth/admin
- Teacher login: https://smart-attendance-lj9c.onrender.com/login/employee
- Student login: https://smart-attendance-lj9c.onrender.com/login/undergraduate

The dashboard and role-specific pages require a signed-in account. Local setup seeds administrator, employee, and student development accounts; the administrator portal can be used to manage them and create additional accounts.

## Administrator Access

Administrator login: https://smart-attendance-lj9c.onrender.com/auth/admin

Account credentials are intentionally omitted from this README. Never commit production credentials or secrets to GitHub.

## Features

- Administrator, employee/teacher, undergraduate, and postgraduate roles
- Teacher/admin session scheduling with classroom coordinates
- HMAC-SHA256 signed QR tokens with expiry validation
- Browser camera scanning and server-side 100-meter GPS distance check
- Duplicate attendance prevention and attendance status tracking
- Daily and weekly student summaries
- Teacher attendance rosters and CSV export
- User, subject, and session management for administrators
- Audit logs, CAPTCHA, CSRF protection, password hashing, and rate limiting
- Optional weekly email reports through SMTP

## Technology

Python 3.11, Flask, SQLAlchemy/Flask-SQLAlchemy, SQLite for local development, PostgreSQL on Render, Jinja2, Tailwind CSS, html5-qrcode, Leaflet/OpenStreetMap, geopy, Flask-Mail, APScheduler, and Gunicorn.

## Run Locally on Windows

Requirements: Python 3.11 or 3.12.

From PowerShell in the project directory:

```powershell
.\setup.ps1
.\start.ps1
```

Open http://127.0.0.1:5000. The local SQLite setup seeds development accounts and sample classes. Keep the server terminal open, then press `Ctrl+C` to stop it.

Manual setup:

```powershell
py -3.11 -m venv venv
.\venv\Scripts\python.exe -m pip install -r requirements.txt
$env:DATABASE_URL = "sqlite:///attendance.db"
$env:SECRET_KEY = "local-development-only"
.\venv\Scripts\python.exe app.py
```

The first local login requires completing the CAPTCHA shown on the page.

## Run Tests

```powershell
.\venv\Scripts\python.exe -m pytest tests/test_core.py -v
```

## Project Layout

- `app.py`: Flask app factory, shared routes, and scheduled reports
- `auth.py`: login, role checks, and audit logging
- `models.py`: database models
- `utils.py`: QR token and location utilities
- `views/`: administrator, teacher, and student routes
- `templates/`: Jinja2 pages and email templates
- `static/`: CSS, images, JavaScript, and generated QR images
- `migrations/`: database migration configuration
- `tests/`: core automated tests
- `render.yaml`: Render web service and PostgreSQL configuration

## Render Deployment

Render is configured by `render.yaml`. The web service runs `gunicorn wsgi:app` and receives `DATABASE_URL` from the linked PostgreSQL database. The web service and database must be available and correctly linked. SMTP settings are optional for attendance, but required to send email reports.
