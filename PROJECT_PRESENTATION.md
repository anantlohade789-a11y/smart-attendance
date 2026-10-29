# Smart Attendance System

## Project Summary

The Smart Attendance System is a web application for recording class attendance. A teacher or administrator creates a class session and displays its QR code. A student scans the code with a browser, shares their current location, and the server checks the QR token, distance to the classroom, and whether attendance was already recorded.

The project is intended to make attendance faster to record, easier to review, and harder to falsify than a paper roll call. It supports administrator, employee/teacher, undergraduate, and postgraduate roles.

## Problem and Proposed Solution

Manual attendance takes class time and is difficult to summarize consistently. A student may also try to check in for someone else. This project combines QR scanning with a location check: the server accepts attendance only when the submitted location is within 100 meters of the session location. Database constraints also prevent a student from recording attendance more than once for the same session.

## Main Workflow

1. An administrator or employee creates a session, selects its subject and time, and specifies the classroom location.
2. The application stores the session and creates an HMAC-signed QR token. A QR image is shown to the class.
3. A logged-in student scans the QR code in a browser and grants camera and location permissions.
4. The server validates the token and its expiry, finds the session, calculates the geodesic distance, and checks for an existing attendance record.
5. The application records the result and makes attendance summaries available to students and class rosters available to staff.

## User Roles

- **Administrator:** Manage users, subjects, and sessions; review statistics and audit logs; trigger administrative jobs.
- **Employee/teacher:** View assigned subjects, create sessions, display session QR codes, review attendance, and export a roster as CSV.
- **Undergraduate/postgraduate student:** Scan a QR code, review daily and weekly attendance, and receive configured email reports.

## Main Components

- `app.py` creates the Flask app, configures extensions, registers routes, and starts the weekly-report scheduler.
- `auth.py` provides login/role checks and audit logging.
- `models.py` defines the SQLAlchemy data models.
- `utils.py` creates and validates QR tokens, generates QR images, and calculates location distance.
- `views/admin.py`, `views/teacher.py`, and `views/student.py` implement role-specific pages and actions.
- `templates/` contains the Jinja2 pages; `static/` contains styles, scripts, and generated QR images.
- `mailer.py` and the email templates handle email reports; `captcha.py` provides the image CAPTCHA.
- `migrations/` contains database migration support; `tests/` contains core behavior tests.

## Data Stored

The main tables represent users, subjects, class sessions, attendance records, family email contacts, and audit events. Attendance records include verification status, scan time, submitted coordinates, and distance from the classroom. A unique student/session constraint prevents duplicate check-ins.

## Technology Used

- **Language and web framework:** Python 3.11, Flask
- **Database access:** SQLAlchemy and Flask-SQLAlchemy; SQLite for local development and PostgreSQL for Render deployment
- **Pages and styling:** Jinja2 templates, HTML, JavaScript, and Tailwind CSS
- **QR scanning and maps:** `html5-qrcode` in the browser, Leaflet with OpenStreetMap
- **Location calculation:** `geopy`
- **Security and forms:** Werkzeug password hashing, HMAC-SHA256 QR signatures, Flask-WTF CSRF protection, Flask-Limiter, and CAPTCHA
- **Email and scheduled work:** Flask-Mail with SMTP and APScheduler
- **Deployment:** Gunicorn on Render, configured in `render.yaml`

## Security and Limitations

QR tokens are signed so their contents cannot be changed without detection, and the server checks token validity and expiry. Location is checked on the server against the stored session coordinates. Passwords are hashed rather than stored as plain text, forms use CSRF protection, and important actions are recorded in audit logs.

Location checks depend on the accuracy and trustworthiness of the browser/device location. A 100-meter geofence is a practical check, not proof against GPS spoofing. A valid QR code can also be shared during its validity window, so the location check and duplicate constraint are important parts of the workflow.

## Suggested Presentation Demonstration

1. Sign in as an administrator and show user management, subjects, sessions, and audit logs.
2. Sign in as an employee and create or open a session to show its QR code and attendance roster.
3. Sign in as a student, open the scanner, and show the daily/weekly attendance pages. For a real scan demonstration, use a device with camera and location permissions and be near the session coordinates.
4. Explain the server-side checks: signed token, token expiry, 100-meter distance, and duplicate prevention.

## Short Presentation Script

“Our project is a role-based attendance web application built with Flask. A staff member creates a class session and displays its QR code. A student scans it and submits their browser location. The server validates the signed token, checks that the student is within 100 meters of the class location, and prevents duplicate attendance. Students can review attendance summaries, staff can manage sessions and rosters, and administrators can manage users and review audit logs. The system uses SQLite locally and PostgreSQL when deployed to Render.”