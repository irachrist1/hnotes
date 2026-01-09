# HNotes - Setup & Installation Guide

This document tracks the development environment setup process, including any errors encountered and their solutions. This will form the basis of your assignment PDF submission.

---

## School Assignment Requirements

**Assignment**: First Flutter Project
**Due Date**: Wednesday, January 15, 2026 by 11:59pm
**Points**: 5

### Requirements Checklist
- [ ] Install Flutter SDK
- [ ] Install Android Studio
- [ ] Create Flutter project
- [ ] Build app displaying "Hello World" + your name
- [ ] Run on Android emulator OR physical device (NOT web browser)
- [ ] Record demo video with:
  - [ ] Current date visible
  - [ ] Your face visible for verification
  - [ ] App clearly running on device/emulator
- [ ] Create PDF with:
  - [ ] Error documentation and solutions
  - [ ] Working video link
- [ ] Submit as: `YourEmailID_FirstFlutterProject.pdf`

---

## Setup Instructions

### Step 1: Install Flutter SDK

**Windows Installation:**

1. Download Flutter SDK from: https://docs.flutter.dev/get-started/install/windows
2. Extract the zip file to `C:\flutter` (avoid paths with spaces or special characters)
3. Add Flutter to PATH:
   - Search "Environment Variables" in Windows
   - Edit "Path" under User variables
   - Add `C:\flutter\bin`
4. Open new Command Prompt and verify:
   ```bash
   flutter --version
   ```

### Step 2: Install Android Studio

1. Download from: https://developer.android.com/studio
2. Run installer with default options
3. After installation, open Android Studio
4. Go to: More Actions → SDK Manager
5. Under "SDK Platforms", install:
   - Android 14.0 (API 34) or latest
6. Under "SDK Tools", install:
   - Android SDK Build-Tools
   - Android SDK Command-line Tools
   - Android Emulator
   - Android SDK Platform-Tools

### Step 3: Create Android Emulator

1. In Android Studio: More Actions → Device Manager
2. Click "Create Device"
3. Select a phone (e.g., Pixel 7)
4. Select a system image (e.g., API 34)
5. Finish setup
6. Click play button to start emulator

### Step 4: Verify Flutter Setup

```bash
flutter doctor
```

Expected output (all green checks):
```
[✓] Flutter (Channel stable, 3.x.x)
[✓] Android toolchain - develop for Android devices
[✓] Android Studio
[✓] Connected device (1 available)
```

### Step 5: Accept Android Licenses

```bash
flutter doctor --android-licenses
```
Press 'y' to accept all licenses.

---

## Running the Hello World App

### Create Project (if not already created)
```bash
cd c:\Users\ChristianTonny\Downloads\Development
flutter create hnotes
cd hnotes
```

### Run on Emulator
```bash
# Start emulator first from Android Studio Device Manager
# Then run:
flutter run
```

---

## PDF Submission 

Create a PDF with the following structure:

```
FIRST FLUTTER PROJECT SUBMISSION

Name: [Your Full Name]
Email: [your_email@alustudent.com]
Date: [Submission Date]

---

1. ENVIRONMENT SETUP

I installed Flutter SDK version [X.X.X] and Android Studio version [X.X].
I ran the application on [emulator name / physical device model].

---

2. ERRORS ENCOUNTERED

Error 1: [Description]
Solution: [How you fixed it]

Error 2: [Description]
Solution: [How you fixed it]

(If no errors: "No significant errors were encountered during setup.")

---

3. DEMO VIDEO

Video Link: [Your URL here]

The video shows:
- The application running on [device/emulator]
- Current date visible
- My face for verification

---

4. SCREENSHOTS (Optional)

[Include relevant screenshots if helpful]
```

---

## File Naming

Save your PDF as:
```
YourEmailID_FirstFlutterProject.pdf
```

Example: If your email is `ctonny@alustudent.com`:
```
ctonny_FirstFlutterProject.pdf
```

---

## Final Checklist Before Submission

- [ ] App displays "Hello World" and your name
- [ ] App runs on emulator or physical device (NOT web browser)
- [ ] Video shows app running with date visible
- [ ] Video shows your face
- [ ] Video link is accessible (test in incognito mode!)
- [ ] PDF includes error documentation
- [ ] PDF includes working video link
- [ ] File is named correctly
- [ ] Submitted before deadline (Wed Jan 15, 11:59pm)
