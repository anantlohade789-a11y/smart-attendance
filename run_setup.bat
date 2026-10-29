@echo off
setlocal
title Smart Attendance System - Easy Setup

echo =====================================================================
echo       SMART ATTENDANCE SYSTEM - 1-CLICK AUTOMATED SETUP
echo =====================================================================
echo.

set "PY_EXE="

:: 1. Search for real Python installation (ignoring Microsoft WindowsApps stub)
if exist "%LOCALAPPDATA%\Programs\Python\Python312\python.exe" (
    set "PY_EXE=%LOCALAPPDATA%\Programs\Python\Python312\python.exe"
) else if exist "%LOCALAPPDATA%\Programs\Python\Python311\python.exe" (
    set "PY_EXE=%LOCALAPPDATA%\Programs\Python\Python311\python.exe"
) else if exist "C:\Python312\python.exe" (
    set "PY_EXE=C:\Python312\python.exe"
) else if exist "C:\Python311\python.exe" (
    set "PY_EXE=C:\Python311\python.exe"
) else if exist "%ProgramFiles%\Python312\python.exe" (
    set "PY_EXE=%ProgramFiles%\Python312\python.exe"
) else if exist "%ProgramFiles%\Python311\python.exe" (
    set "PY_EXE=%ProgramFiles%\Python311\python.exe"
)

if not defined PY_EXE (
    where py >nul 2>&1
    if not errorlevel 1 set "PY_EXE=py"
)

if not defined PY_EXE (
    echo [ERROR] Real Python executable not found!
    echo Please make sure Python 3.12 is installed.
    pause
    exit /b 1
)

echo [1/4] Real Python detected at:
echo       "%PY_EXE%"
"%PY_EXE%" --version
echo.

echo [2/4] Setting up isolated Python virtual environment (venv)...
if not exist "venv\Scripts\python.exe" (
    "%PY_EXE%" -m venv venv
    if errorlevel 1 (
        echo [ERROR] Failed to create virtual environment.
        pause
        exit /b 1
    )
    echo     -> Virtual environment created successfully!
) else (
    echo     -> Virtual environment already exists.
)
echo.

echo [3/4] Installing required libraries (Flask, SQLAlchemy, geopy, etc.)...
echo       (This may take 1-2 minutes depending on your internet connection)
"venv\Scripts\python.exe" -m pip install --upgrade pip --quiet
"venv\Scripts\pip.exe" install -r requirements.txt
if errorlevel 1 (
    echo [ERROR] Dependency installation encountered an issue.
    pause
    exit /b 1
)
echo     -> All libraries installed successfully!
echo.

echo [4/4] Setting up SQLite database with demo accounts and sample classes...
"venv\Scripts\python.exe" seed_data.py
if errorlevel 1 (
    echo [WARNING] Seeding returned an alert, attempting init_db...
    "venv\Scripts\python.exe" init_db.py
)
)
echo.

echo =====================================================================
echo                     SETUP COMPLETED SUCCESSFULLY!
echo =====================================================================
echo.
echo You are ready to run the project!
echo.
echo To start the application:
echo    Double-click "start_app.bat" or in PowerShell type: ".\start_app.bat"
echo.
echo Login Credentials:
echo   - Admin Portal:   http://127.0.0.1:5000/auth/admin
echo     Email:          admin@school.test
echo     Password:       Test1234!
echo.
echo   - Teacher Portal: http://127.0.0.1:5000/login/employee
echo     Email:          employee@school.test
echo     Password:       Test1234!
echo.
echo   - Student Portal: http://127.0.0.1:5000/login/undergraduate
echo     Email:          student1@school.test
echo     Password:       Test1234!
echo.
echo Press any key to close this window...
pause >nul
