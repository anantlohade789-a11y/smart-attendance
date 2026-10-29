# Complete Beginner Setup Guide (Zero-Coding Required)

Welcome! This guide is written specifically for you so that you can set up, run, and demonstrate your **Smart Attendance System** college project with **zero prior coding experience**.

---

## ⚡ Quick 3-Step Summary (If you're in a hurry)

1. **Install Python** from [python.org](https://www.python.org/downloads/) *(Make sure to check "Add python.exe to PATH")*.
2. **Double-click `run_setup.bat`** in this project folder.
3. **Double-click `start_app.bat`** to launch the project in your browser!

---

## 📋 Table of Contents
1. [Prerequisites: Installing Python (The Right Way)](#step-1-install-python-on-windows)
2. [Automated 1-Click Setup](#step-2-run-the-automated-setup)
3. [Starting the Application](#step-3-starting-the-application)
4. [Live Demo Walkthrough (For Your College Presentation)](#step-4-college-presentation-demo-walkthrough)
5. [How to Test Student QR Scanning (Webcam & Phone)](#step-5-testing-the-qr-scanner--gps)
6. [Resetting the Database Anytime](#step-6-resetting-the-database-anytime)
7. [Troubleshooting & Common Errors](#step-7-troubleshooting--common-issues)

---

## Step 1: Install Python on Windows

Your computer needs **Python** to run this project. If you don't already have it, follow these exact steps:

1. Open your browser and go to: **[https://www.python.org/downloads/](https://www.python.org/downloads/)**
2. Click the big yellow button: **"Download Python 3.12"** (or 3.11).
3. Open the downloaded `.exe` file.
4. ⚠️ **VERY IMPORTANT (DO NOT MISS THIS):**
   - At the bottom of the installer window, you will see a checkbox:
     ```
     [X] Add python.exe to PATH
     ```
   - **Check this box!** If you forget to check this, Windows won't recognize Python.
5. Click **"Install Now"**.
6. When the setup finishes, click **"Close"**.

---

## Step 2: Run the Automated Setup

We have created an automated setup script that does all the technical work for you:
- Creates an isolated virtual environment (`venv`)
- Installs all required libraries (`Flask`, `SQLAlchemy`, `geopy`, `Pillow`, etc.)
- Sets up the database and pre-loads sample teachers, students, subjects, and classes

### How to run it:
1. Open this project folder in Windows File Explorer:
   `C:\Users\anant\Downloads\smart-attendance-system-main`
2. Find the file named **`run_setup.bat`** (or `run_setup`).
3. **Double-click it.**
4. A black terminal window will open and perform all 4 setup steps automatically.
5. Wait 1-2 minutes until you see:
   ```
   =====================================================================
                     SETUP COMPLETED SUCCESSFULLY!
   =====================================================================
   ```
6. Press any key to close the window.

---

## Step 3: Starting the Application

Whenever you want to start the project:

1. In the project folder, double-click **`start_app.bat`**.
2. The server will start, and within 3 seconds, your default web browser (Chrome / Edge) will automatically open:
   👉 **`http://127.0.0.1:5000`**
3. Keep the black terminal window open while you use the website.
4. To stop the website, close the black terminal window or press `Ctrl + C`.

---

## Step 4: College Presentation Demo Walkthrough

When presenting this project to your college professor or external viva examiner, follow this 4-step live demonstration flow:

### 🔑 Demo Login Accounts

| Role | Login Page | Email | Password |
| :--- | :--- | :--- | :--- |
| **Admin** | `http://127.0.0.1:5000/auth/admin` | `admin@school.test` | `Test1234!` |
| **Teacher** | `http://127.0.0.1:5000/login/employee` | `employee@school.test` | `Test1234!` |
| **Student** | `http://127.0.0.1:5000/login/undergraduate` | `student1@school.test` | `Test1234!` |

*(Note: On the login page, you will see a 4-letter CAPTCHA image. Type those letters into the verification box to log in).*

---

### Step 4.1: Show the Admin Dashboard
1. Go to `http://127.0.0.1:5000/auth/admin`.
2. Login with `admin@school.test` / `Test1234!`.
3. **What to highlight to your examiner**:
   - Total Students, Teachers, Subjects, and Attendance records counter.
   - Click **"User Management"** to show how admins can add, filter, or deactivate students/teachers.
   - Click **"Audit Logs"** to show security monitoring (every login and attendance check is tracked with an IP address).

---

### Step 4.2: Show the Teacher Dashboard & Create a Class Session
1. Log out, then go to `http://127.0.0.1:5000/login/employee`.
2. Login with `employee@school.test` / `Test1234!`.
3. **What to highlight**:
   - View assigned subjects (e.g. *Introduction to Computer Science*, *Data Structures*).
   - Click **"Create Session"**:
     - Pick a subject.
     - Set start and end times.
     - **Click on the interactive map** to set where the class is physically held.
     - Click **Save Session**.
4. Click on an ongoing session:
   - The screen will display a **large QR Code**.
   - Explain to the examiner: *"This QR code contains an HMAC-SHA256 encrypted token that expires after 30 minutes to prevent sharing."*

---

### Step 4.3: Show the Student Scanning & Marking Attendance
1. In another browser tab (or Incognito window), go to `http://127.0.0.1:5000/login/undergraduate`.
2. Login with `student1@school.test` / `Test1234!`.
3. Click **"Scan QR"** in the top navigation.
4. Allow Camera and Location permissions when the browser asks.
5. Point the webcam at the teacher's QR code (or show the QR image).
6. The system immediately:
   - Captures student GPS coordinates.
   - Calculates distance to the classroom.
   - If within 100 meters, displays: `✓ Attendance Verified Successfully!`.
   - If too far, displays: `✗ Too far from session location (Rejected)`.
7. Student dashboard instantly updates to show today's attended class!

---

## Step 5: Testing the QR Scanner & GPS

### Option A: Testing on Your Laptop (Easiest)
1. Open the Teacher QR code on your phone screen or on a split browser window.
2. Log into the Student portal on your laptop and click **"Scan QR"**.
3. Hold your phone with the QR code up to your laptop webcam.
4. Click **Allow** when Chrome asks for Camera & Location permissions.

> [!TIP]
> **Simulating GPS Location in Chrome**:
> If the sample session location in the database is far from your current house/college:
> 1. In Chrome, press `F12` to open Developer Tools.
> 2. Press `Ctrl + Shift + P`, type `Sensors`, and press `Enter`.
> 3. Under **Location**, select **Custom location** and paste the exact latitude and longitude of the teacher's session!

---

### Option B: Testing from a Real Mobile Phone (Using Ngrok)
Modern phone browsers (iOS Safari, Android Chrome) strictly block camera and GPS access unless the website uses **HTTPS**.

Your project already comes with **`ngrok.exe`** pre-installed in the folder:
`ngrok-v3-stable-windows-amd64\ngrok.exe`

To access your laptop's server from your phone:
1. Start the server using `start_app.bat`.
2. Open a separate Command Prompt and run:
   ```cmd
   cd ngrok-v3-stable-windows-amd64
   ngrok.exe http 5000
   ```
3. Ngrok will give you a public secure URL like:
   `https://a1b2-c3d4.ngrok-free.app`
4. Open that `https://...` link on your smartphone! You can now scan the laptop's QR code directly with your phone's camera!

---

## Step 6: Resetting the Database Anytime

If you want to clear test data and start fresh with pristine demo accounts before your college presentation:
1. Double-click **`reset_database.bat`**.
2. Press `Y` when prompted.
3. The script automatically clears old test check-ins and re-seeds clean demo data!

---

## Step 7: Troubleshooting & Common Issues

### Issue 1: "python is not recognized as an internal or external command"
- **Reason**: Python was installed without checking the PATH box.
- **Solution**: Re-run the Python installer, select **Modify**, and make sure **"Add Python to environment variables / PATH"** is checked. Then restart your computer.

### Issue 2: "Port 5000 is already in use"
- **Reason**: Another app or a previous instance of Python is still running on port 5000.
- **Solution**: Open Command Prompt and run:
  ```cmd
  netstat -ano | findstr :5000
  ```
  Note the PID number at the far right and kill it:
  ```cmd
  taskkill /PID <number> /F
  ```
  Or simply restart your computer.

### Issue 3: "Camera permission denied" or "Location permission denied"
- **Reason**: The browser blocked permissions.
- **Solution**: Click the little lock/tune icon on the left of the address bar (`http://127.0.0.1:5000`), find **Camera** and **Location**, and change them from *Block* to *Allow*. Then refresh the page.

### Issue 4: "Invalid verification code" on Login
- **Reason**: The 4-character visual CAPTCHA was mistyped.
- **Solution**: CAPTCHA is case-sensitive (or clear uppercase letters). Type the characters shown in the box, or click the image to refresh it.
