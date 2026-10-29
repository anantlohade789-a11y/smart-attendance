# =====================================================================
#       SMART ATTENDANCE SYSTEM - LAUNCH SERVER
# =====================================================================

if (-not (Test-Path "venv\Scripts\python.exe")) {
    Write-Host "[ERROR] Virtual environment not found!" -ForegroundColor Red
    Write-Host "Please run .\setup.ps1 first." -ForegroundColor Yellow
    Exit 1
}

Write-Host "Starting Flask server at http://127.0.0.1:5000 ..." -ForegroundColor Cyan
Start-Process "http://127.0.0.1:5000"

Write-Host "Server is running! Press Ctrl+C anytime to stop." -ForegroundColor Green
Write-Host ""

& "venv\Scripts\python.exe" app.py
