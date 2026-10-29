# =====================================================================
#       SMART ATTENDANCE SYSTEM - POWERSHELL AUTOMATED SETUP
# =====================================================================

Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host "      SMART ATTENDANCE SYSTEM - 1-CLICK AUTOMATED SETUP" -ForegroundColor Cyan
Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host ""

# 1. Locate real Python (ignoring Microsoft Store dummy stub)
$pyCandidates = @(
    "$env:LOCALAPPDATA\Programs\Python\Python312\python.exe",
    "$env:LOCALAPPDATA\Programs\Python\Python311\python.exe",
    "C:\Python312\python.exe",
    "C:\Python311\python.exe",
    "$env:ProgramFiles\Python312\python.exe",
    "$env:ProgramFiles\Python311\python.exe"
)

$pyExe = $null
foreach ($cand in $pyCandidates) {
    if (Test-Path $cand) {
        $pyExe = $cand
        break
    }
}

if (-not $pyExe) {
    $found = Get-Command python -ErrorAction SilentlyContinue | Where-Object { $_.Source -notlike "*WindowsApps*" } | Select-Object -ExpandProperty Source -First 1
    if ($found) { $pyExe = $found }
}

if (-not $pyExe) {
    Write-Host "[ERROR] Could not find your Python 3.12 installation!" -ForegroundColor Red
    Write-Host "Please ensure Python 3.12 is installed."
    Exit 1
}

Write-Host "[1/4] Real Python detected at:" -ForegroundColor Green
Write-Host "      $pyExe" -ForegroundColor Yellow
& $pyExe --version
Write-Host ""

# 2. Virtual environment setup
Write-Host "[2/4] Setting up isolated Python environment (venv)..." -ForegroundColor Green
if (-not (Test-Path "venv\Scripts\python.exe")) {
    & $pyExe -m venv venv
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ERROR] Failed to create virtual environment." -ForegroundColor Red
        Exit 1
    }
    Write-Host "      -> Virtual environment created successfully!" -ForegroundColor Green
} else {
    Write-Host "      -> Virtual environment already exists." -ForegroundColor Yellow
}
Write-Host ""

# 3. Install requirements
Write-Host "[3/4] Installing required libraries (Flask, SQLAlchemy, geopy, etc.)..." -ForegroundColor Green
Write-Host "      (This may take 1-2 minutes depending on internet speed...)" -ForegroundColor Gray
& "venv\Scripts\python.exe" -m pip install --upgrade pip --quiet
& "venv\Scripts\pip.exe" install -r requirements.txt

if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Error during library installation." -ForegroundColor Red
    Exit 1
}
Write-Host "      -> All libraries installed successfully!" -ForegroundColor Green
Write-Host ""

# 4. Initialize Database
Write-Host "[4/4] Setting up SQLite database with demo accounts & sessions..." -ForegroundColor Green
& "venv\Scripts\python.exe" seed_data.py

Write-Host ""
Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host "                     SETUP COMPLETED SUCCESSFULLY!                   " -ForegroundColor Cyan
Write-Host "=====================================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "To start the project, simply run:" -ForegroundColor White
Write-Host "   .\start.ps1   (or double-click start_app.bat)" -ForegroundColor Yellow
Write-Host ""
Write-Host "Login Credentials:" -ForegroundColor White
Write-Host "   - Admin Portal:   http://127.0.0.1:5000/auth/admin (admin@school.test / Test1234!)" -ForegroundColor Gray
Write-Host "   - Teacher Portal: http://127.0.0.1:5000/login/employee (employee@school.test / Test1234!)" -ForegroundColor Gray
Write-Host "   - Student Portal: http://127.0.0.1:5000/login/undergraduate (student1@school.test / Test1234!)" -ForegroundColor Gray
Write-Host ""
