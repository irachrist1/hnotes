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

## Error Log

Document any errors you encounter below. This section will be included in your PDF submission.

### Error 1: [Title]
**Date**:
**Description**:

**Solution**:

---

### Error 2: [Title]
**Date**:
**Description**:

**Solution**:

---

### Error 3: [Title]
**Date**:
**Description**:

**Solution**:

---

## Common Errors & Solutions

### "flutter: command not found"
**Cause**: Flutter not added to PATH
**Solution**:
1. Verify Flutter is extracted to `C:\flutter`
2. Add `C:\flutter\bin` to PATH environment variable
3. Restart Command Prompt/Terminal

### "Android SDK not found"
**Cause**: Android Studio SDK not configured
**Solution**:
1. Open Android Studio
2. Go to SDK Manager
3. Note the SDK location path
4. Run: `flutter config --android-sdk "C:\Users\YourName\AppData\Local\Android\Sdk"`

### "No connected devices"
**Cause**: Emulator not running or device not connected
**Solution**:
1. Start Android emulator from Device Manager
2. OR connect physical device with USB debugging enabled
3. Run `flutter devices` to verify

### "License not accepted"
**Cause**: Android SDK licenses need acceptance
**Solution**:
```bash
flutter doctor --android-licenses
```
Accept all licenses by pressing 'y'.

### Emulator runs slowly
**Cause**: Hardware acceleration not enabled
**Solution**:
1. Enable Hyper-V in Windows Features
2. OR install Intel HAXM from SDK Manager
3. Ensure virtualization is enabled in BIOS

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

### Run on Physical Device
1. Enable Developer Options on your Android phone:
   - Go to Settings → About Phone
   - Tap "Build Number" 7 times
2. Enable USB Debugging:
   - Settings → Developer Options → USB Debugging
3. Connect phone via USB
4. Run:
```bash
flutter devices  # Verify device is listed
flutter run      # Run on device
```

---

## Recording Demo Video

### Requirements
1. **Show current date**: Have a clock/calendar visible on screen or say the date
2. **Show your face**: Brief appearance for identity verification
3. **Show app running**: Clear view of "Hello World" and your name on emulator/device

### Recording Tips
- Use OBS Studio (free) or Windows Game Bar (Win+G)
- For emulator: Record your entire screen
- For physical device: Point camera at phone screen
- Keep video under 2 minutes
- Speak clearly if providing voice narration

### Upload Options
1. **YouTube** (Unlisted): Most reliable, paste link in PDF
2. **Google Drive**: Share with "Anyone with link can view"
3. **OneDrive**: Create shareable link

**IMPORTANT**: Test your video link in an incognito browser window before submitting!

---

## PDF Submission Template

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
