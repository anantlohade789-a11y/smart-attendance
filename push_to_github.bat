@echo off
title Push Project to GitHub
echo =====================================================================
echo                 PUSH TO GITHUB (AUTOMATED)
echo =====================================================================
echo.

where git >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Git is not installed yet!
    echo.
    echo To install Git in 10 seconds:
    echo 1. Open PowerShell and run:  winget install --id Git.Git -e --source winget
    echo    OR download from:        https://git-scm.com/download/win
    echo 2. Once installed, run this file again!
    echo.
    pause
    exit /b 1
)

echo [1/4] Initializing Git repository...
if not exist ".git" git init
git config user.name "Anant Lohade"
git config user.email "anantlohade@users.noreply.github.com"

echo [2/4] Staging files for commit...
git add .

echo [3/4] Creating commit...
git commit -m "Deploy Smart Attendance System to Render" >nul 2>&1

echo [4/4] Connecting to GitHub repository...
git branch -M main
git remote remove origin >nul 2>&1
git remote add origin https://github.com/anantlohade789-a11y/smart-attendance.git

echo.
echo Pushing code to GitHub...
echo (A GitHub login pop-up window may appear in your browser. Just click Authorize!)
echo.
git push -u origin main

echo.
echo =====================================================================
echo Push complete! Go to https://github.com/anantlohade789-a11y/smart-attendance
echo =====================================================================
pause
