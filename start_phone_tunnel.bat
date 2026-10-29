@echo off
title Smart Attendance System - Mobile Phone Tunnel (Ngrok)
echo =====================================================================
echo           EXPOSE FLASK TO YOUR MOBILE PHONE VIA NGROK
echo =====================================================================
echo.
echo NOTE: Make sure "start_app.bat" is already running!
echo.
echo When Ngrok starts, look for the line that says:
echo      Forwarding   https://xxxx-xxxx.ngrok-free.app -> http://localhost:5000
echo.
echo Open that "https://..." link in your smartphone browser!
echo =====================================================================
echo.

cd /d "%~dp0ngrok-v3-stable-windows-amd64"
ngrok.exe http 5000
pause
