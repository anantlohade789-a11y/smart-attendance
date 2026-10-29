# Complete Guide: Push to GitHub & Deploy to Render

This step-by-step guide is designed so you can take this project, publish it to your GitHub account (`anantlohade789-a11y`), and deploy it live on **Render.com** with **zero prior cloud experience**.

---

## 📋 Overview of What We Will Do

```mermaid
flowchart LR
    A["1. Project Files on Laptop"] -->|"Push via GitHub Desktop"| B["2. GitHub Repo (anantlohade789-a11y)"]
    B -->|"Auto-Deploy with render.yaml"| C["3. Render Cloud Web Service"]
    C -->|"Live Public URL"| D["4. Accessible from Any Phone / Laptop"]
```

---

## Part 1: Push Code to Your GitHub Account

Since Git command-line is not installed yet on your computer, the **easiest and cleanest method** is using **GitHub Desktop** (Official free app by GitHub).

### Step 1.1: Download & Sign In to GitHub Desktop
1. Download GitHub Desktop: **[https://desktop.github.com/](https://desktop.github.com/)**
2. Run the installer.
3. When it opens, click **"Sign in to GitHub.com"**.
4. It will open your browser—authorize it for your account (`anantlohade789-a11y`).

---

### Step 1.2: Add This Project Folder
1. In GitHub Desktop, click the menu: **File** -> **Add Local Repository...** (or press `Ctrl + O`).
2. Click **Choose...** and browse to your project folder:
   `C:\Users\anant\Downloads\smart-attendance-system-main`
3. Click **Add Repository**.
   *(If GitHub Desktop says "This directory does not appear to be a Git repository", simply click the blue link: **"create a repository"**, keep the defaults, and click **"Create Repository"**).*

---

### Step 1.3: Publish to GitHub
1. In the top bar of GitHub Desktop, click the blue button: **"Publish repository"**.
2. Settings:
   - **Name**: `smart-attendance`
   - **Keep this code private**: Uncheck this box if you want it to be Public (Public repositories get completely free hosting on Render).
3. Click **"Publish Repository"**.
4. In 10–20 seconds, your code is live on:  
   👉 `https://github.com/anantlohade789-a11y/smart-attendance`

---

## Part 2: Deploy to Render (1-Click Blueprint)

Because I already created the configuration file **[`render.yaml`](file:///c:/Users/anant/Downloads/smart-attendance-system-main/render.yaml)** in your project, Render will automatically set up both the **Web Server** and the **PostgreSQL Database** together.

### Step 2.1: Open Render Dashboard
1. Go to **[https://dashboard.render.com/](https://dashboard.render.com/)** (you are already logged in with your GitHub account).
2. At the top right, click the blue button: **"New +"**.
3. Select **"Blueprint"**.

---

### Step 2.2: Connect Your GitHub Repository
1. You will see a list of your GitHub repositories.
2. Find **`smart-attendance`** and click **"Connect"**.
   *(If you don't see it, click "Configure account" and give Render permission to access the `smart-attendance` repository).*
3. Give your Blueprint a name (e.g. `smart-attendance-blueprint`).
4. Click **"Apply"**.

---

### Step 2.3: Watch It Deploy Automatically!
Render will now read the `render.yaml` configuration and perform the following automatically:
1. ✅ Provision a free **PostgreSQL Database** (`attendance-db`).
2. ✅ Connect the database to the Flask application automatically (`DATABASE_URL`).
3. ✅ Install all required libraries (`Flask`, `SQLAlchemy`, `gunicorn`, `geopy`, etc.).
4. ✅ Start the web server using `gunicorn wsgi:app`.
5. ✅ Create the default administrator on startup if the database is empty:
   - Credentials are provisioned by the application and are not listed in this guide.

Wait about 3–5 minutes until you see the green **"Live"** badge!

---

## Part 3: Accessing Your Live Website

1. On your Render dashboard, click on your **smart-attendance** Web Service.
2. At the top left, under the service name, you will see your live public URL:
   👉 **`https://smart-attendance-lj9c.onrender.com`**
3. Open this link on your laptop, or send it to your smartphone!

### Testing from Mobile Phone
- Because Render gives you an official **`https://`** certificate, you can open this link on **any iPhone or Android phone** anywhere in the world!
- Create employee and student accounts from the administrator portal before testing those roles. On the student account, tap **"Scan QR"**; camera and GPS require browser permissions.

---

## 🔑 Production Login Credentials

| Role | Portal URL | Email | Password |
| :--- | :--- | :--- | :--- |
| **System Admin** | `https://smart-attendance-lj9c.onrender.com/auth/admin` | Provisioned separately | Provisioned separately |
| **Faculty / Teacher** | `https://smart-attendance-lj9c.onrender.com/login/employee` | Created in the admin portal | Set when creating the user |
| **Student** | `https://smart-attendance-lj9c.onrender.com/login/undergraduate` | Created in the admin portal | Set when creating the user |

The app seeds development accounts and sample classes when the database is empty. Change the default passwords and remove unused sample data before using the deployment with real users.
