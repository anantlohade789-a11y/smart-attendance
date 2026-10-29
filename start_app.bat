@echo off
title Smart Attendance System - Running Server
echo =====================================================================
echo              STARTING SMART ATTENDANCE SYSTEM
echo =====================================================================
echo.

if not exist "venv\Scripts\activate.bat" (
    echo [ERROR] Virtual environment not found!
    echo Please run "run_setup.bat" first to complete installation.
    echo.
    pause
    exit /b 1
)

echo Activating environment...
call venv\Scripts\activate.bat

echo Opening browser at http://127.0.0.1:5000 in 3 seconds...
start "" cmd /c "timeout /t 3 /nobreak >nul && start http://127.0.0.1:5000"

echo.
echo =====================================================================
echo Server is running! Press Ctrl+C in this window anytime to stop.
echo =====================================================================
echo.
venv\Scripts\python.exe app.py
pause
