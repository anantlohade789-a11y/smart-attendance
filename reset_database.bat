@echo off
title Smart Attendance System - Reset Database
echo =====================================================================
echo                RESET DATABASE TO DEMO STATE
echo =====================================================================
echo.
echo WARNING: This permanently deletes the local database and recreates
echo the development accounts and sample classes.
echo.
set /p confirm="Are you sure you want to proceed? (Y/N): "
if /i not "%confirm%"=="Y" (
    echo Reset cancelled.
    pause
    exit /b 0
)

if not exist "venv\Scripts\activate.bat" (
    echo [ERROR] Virtual environment not found. Please run run_setup.bat first.
    pause
    exit /b 1
)

call venv\Scripts\activate.bat

if exist "instance\attendance.db" del /f /q "instance\attendance.db"
if exist "attendance.db" del /f /q "attendance.db"

echo.
echo Re-seeding development data...
python seed_data.py

echo.
echo =====================================================================
echo Database reset complete! You can now start the app with start_app.bat
echo =====================================================================
echo.
pause
