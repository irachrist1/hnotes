# HNotes - Task Tracker & Roadmap

## Current Status: Phase 1 - Bug Fixes & Feature Completion

---

## CRITICAL BUGS TO FIX (January 8, 2026)

### Bug #1: Health Permissions Not Working ⚠️
- **Issue:** App does NOT request Android Health Connect permissions from user
- **Expected:** After profile setup, app should trigger OS permission dialog
- **Root Cause:** Missing `Health().configure()` call before requesting authorization
- **Files Fixed:**
  - `android/app/src/main/AndroidManifest.xml` - Added Health Connect intent-filter
  - `lib/features/health/services/health_service.dart` - Added configure() call
- **Status:** ✅ FIXED

### Bug #2: Goal Selection Card Visual Issues ⚠️
- **Issue:** Selected goal card looks "washed out" with poor contrast
- **Root Cause:** Using `AppColors.skyBlue.withOpacity(0.1)` makes selection nearly invisible
- **File Fixed:** `lib/features/onboarding/screens/goal_selection_screen.dart`
- **Solution:** Changed to solid styling with better border and shadow contrast
- **Status:** ✅ FIXED

### Bug #3: Meal History & Logging Disconnected ⚠️
- **Issue:** 
  - Quick Actions at bottom of dashboard, hard to find
  - No "Log Activity" button exists
  - FAB overlaps content
- **Files Fixed:**
  - `lib/features/dashboard/screens/dashboard_screen.dart` - Added Log Activity button
  - `lib/features/burn_tracking/screens/activity_input_screen.dart` - NEW FILE
- **Status:** ✅ FIXED

### Bug #4: Settings Screen Placeholders ⚠️
- **Issue:** Most settings show "Coming soon!" with no functionality
- **File Fixed:** `lib/features/settings/screens/settings_screen.dart`
- **Status:** ✅ FIXED

### Bug #5: Mock Notifications - No Real System ⚠️
- **Issue:** Notifications screen shows hardcoded mock data
- **Files Fixed:**
  - `lib/data/models/app_notification.dart` - NEW FILE
  - `lib/shared/providers/notification_provider.dart` - NEW FILE
  - `lib/features/notifications/screens/notifications_screen.dart` - Updated
- **Status:** ✅ FIXED

### Bug #6: MealInputScreen Button Visibility ⚠️
- **Issue:** Buttons disappear or have visibility issues
- **File Fixed:** `lib/features/intake_tracking/screens/meal_input_screen.dart`
- **Status:** ✅ FIXED

---

## Phase 0: Environment Setup & School Assignment
**Deadline: January 15, 2026 (Wednesday 11:59pm)**

### To Do
- [ ] Record demo video with date visible and face shown
- [ ] Document any errors and solutions
- [ ] Create PDF submission
- [ ] Submit assignment

### Completed
- [x] Install Flutter SDK
- [x] Install Android Studio
- [x] Configure Android emulator
- [x] Create Flutter project
- [x] Build app with name displayed
- [x] Run app on emulator/device
- [x] Created project folder structure
- [x] Created documentation (idea.md, tasks.md, plan.md, setup.md)

---

## Phase 1: Core App Structure (Week 2-3)
### To Do
- [ ] Fix UI overflow on Pixel 6 Pro (75px overflow) - needs physical device testing

### Completed
- [x] Set up project architecture (folders, state management)
- [x] Create main navigation structure
- [x] Design and implement home dashboard UI
- [x] Create onboarding flow screens
- [x] Fix color consistency (gradient across all onboarding screens)
- [x] Implement state management with Provider
- [x] Add input pickers (age, height, weight) with scroll wheel
- [x] Implement data persistence with SharedPreferences
- [x] Create splash screen with onboarding check
- [x] Fix goal card text contrast on selection
- [x] Implement Settings screen (view profile, update weight, logout)
- [x] Implement Notifications screen with real notification provider
- [x] Fix Health Connect permissions request flow
- [x] Add Activity Input Screen
- [x] Fix Quick Actions accessibility on Dashboard

---

## Phase 2: Calorie Burn Tracking (Week 3-4)
### To Do
- [ ] Integrate Android Health Connect API
- [ ] Request necessary permissions
- [ ] Fetch step count data
- [ ] Calculate calories burned from steps
- [ ] Display daily burn stats on dashboard
- [ ] Create burn history/graph view

### In Progress
(none)

### Completed
(none)

---

## Phase 3: AI-Powered Calorie Intake (Week 4-5)
### To Do
- [ ] Set up Perplexity Sonar API integration
- [ ] Create natural language input UI
- [ ] Implement food-to-calorie conversion
- [ ] Store meal history locally
- [ ] Display intake stats on dashboard
- [ ] Create meal history view

### In Progress
(none)

### Completed
(none)

---

## Phase 4: Dashboard & Analytics (Week 5-6)
### To Do
- [ ] Implement burn vs. intake comparison graph
- [ ] Calculate daily calorie balance
- [ ] Create progress visualization
- [ ] Add weekly/monthly trend views
- [ ] Implement goal progress tracking

### In Progress
(none)

### Completed
(none)

---

## Phase 5: AI Daily Guidance (Week 6-7)
### To Do
- [ ] Design guidance algorithm
- [ ] Implement daily action recommendations
- [ ] Create "What To Do Today" widget
- [ ] Add notification system for reminders
- [ ] Implement progress encouragement messages

### In Progress
(none)

### Completed
(none)

---

## Phase 6: Polish & Testing (Week 7-8)
### To Do
- [ ] UI/UX refinement
- [ ] Performance optimization
- [ ] Bug fixes
- [ ] User testing
- [ ] Final documentation

### In Progress
(none)

### Completed
(none)

---

## Known Issues / Blockers
| Issue | Status | Resolution |
|-------|--------|------------|
| (none yet) | | |

---

## Notes
- Update this file after completing each task
- Move items between sections as work progresses
- Add new issues to Known Issues section
- Keep timestamps for significant completions
