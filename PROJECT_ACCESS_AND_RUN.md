# Project Access and Run Guide

## Hosted Links

Base URL: https://smart-attendance-lj9c.onrender.com

| Page | Direct URL |
| --- | --- |
| Student dashboard | https://smart-attendance-lj9c.onrender.com/student/dashboard |
| Home | https://smart-attendance-lj9c.onrender.com/ |
| Administrator login | https://smart-attendance-lj9c.onrender.com/auth/admin |
| Administrator dashboard | https://smart-attendance-lj9c.onrender.com/admin/dashboard |
| Employee login | https://smart-attendance-lj9c.onrender.com/login/employee |
| Employee dashboard | https://smart-attendance-lj9c.onrender.com/teacher/dashboard |
| Undergraduate login | https://smart-attendance-lj9c.onrender.com/login/undergraduate |
| Postgraduate login | https://smart-attendance-lj9c.onrender.com/login/postgraduate |
| QR scanner | https://smart-attendance-lj9c.onrender.com/student/scan |
| Daily attendance | https://smart-attendance-lj9c.onrender.com/student/attendance/daily |
| Weekly attendance | https://smart-attendance-lj9c.onrender.com/student/attendance/weekly |
| Teacher session creation | https://smart-attendance-lj9c.onrender.com/teacher/sessions/create |
| Admin user management | https://smart-attendance-lj9c.onrender.com/admin/users |
| Admin subject creation | https://smart-attendance-lj9c.onrender.com/admin/subjects/create |
| Admin session creation | https://smart-attendance-lj9c.onrender.com/admin/sessions/create |
| Admin audit logs | https://smart-attendance-lj9c.onrender.com/admin/audit_logs |
| Forgot password | https://smart-attendance-lj9c.onrender.com/forgot-password |

Non-login pages require an authenticated account with the appropriate role. The seed script creates local development accounts; use the administrator's user-management page to create additional accounts.

## Administrator Login

- Login page: https://smart-attendance-lj9c.onrender.com/auth/admin

Login credentials are intentionally omitted from this Markdown guide. Local setup seeds administrator, employee, and student development accounts, plus sample classes.

## Local Development

Requirements: Python 3.11 or 3.12. Open PowerShell in the project directory and run:

```powershell
.\setup.ps1
.\start.ps1
```

Open http://127.0.0.1:5000. The first login requires completing the displayed CAPTCHA. Leave the server terminal open while testing; press `Ctrl+C` to stop it.

Manual setup alternative:

```powershell
py -3.11 -m venv venv
.\venv\Scripts\python.exe -m pip install -r requirements.txt
$env:DATABASE_URL = "sqlite:///attendance.db"
$env:SECRET_KEY = "local-development-only"
.\venv\Scripts\python.exe app.py
```

The local database uses SQLite. Running `seed_data.py` adds the development accounts and sample classes if they are missing; it does not reset passwords for existing accounts.

## Tests

```powershell
.\venv\Scripts\python.exe -m pytest tests/test_core.py -v
```

## Render Configuration

`render.yaml` configures Gunicorn with `wsgi:app` and links `DATABASE_URL` to the Render PostgreSQL service. The Render web service and database must be available and correctly linked. SMTP variables are required only for sending email reports.
