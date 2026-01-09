# HNotes - Non-Functional Features Audit
**Date:** January 8, 2026  
**Status:** Comprehensive analysis of incomplete/non-functional features

---

## ✅ FIXED ISSUES (No longer issues)
### 1. Health Permissions ✅
- **Status:** WORKING - Triggers Android Health Connect permissions dialog
- **Location:** Health Permissions Screen after onboarding

### 2. Goal Selection Cards ✅
- **Status:** WORKING - Proper visual contrast on selection
- **Location:** Goal Selection Screen (onboarding)

### 3. Log Activity Button ✅
- **Status:** WORKING - Activity Input Screen created and integrated
- **Location:** Dashboard Quick Actions

### 4. Notifications System ✅
- **Status:** WORKING - Real NotificationProvider with persistence
- **Location:** Notifications Screen

### 5. Settings Functionality ✅
- **Status:** WORKING - Health Permissions, Notification Settings, Theme Settings, Privacy Policy all functional
- **Location:** Settings Screen

### 6. Meal Input Button ✅
- **Status:** WORKING - Button properly visible at bottom of screen
- **Location:** Meal Input Screen

### 7. Number Pickers ✅
- **Status:** WORKING - Replaced with simple text input fields
- **Location:** Profile Setup Screen (age, height, weight inputs)

### 8. Mock Data ✅
- **Status:** REMOVED - PerplexityService now throws errors if API not configured
- **Note:** No longer using fallback mock data

---

## ⚠️ NOT FUNCTIONAL / INCOMPLETE FEATURES

### 1. Perplexity AI Meal Analysis ⚠️
- **Status:** NOT CONFIGURED
- **Issue:** API key not set (shows 'YOUR_PERPLEXITY_API_KEY_HERE')
- **Impact:** Cannot analyze meals using natural language
- **Location:** `lib/features/intake_tracking/services/perplexity_service.dart`
- **Required:** User must add Perplexity API key to use meal analysis
- **Files Affected:**
  - `perplexity_service.dart` - Line 6: `static const String _apiKey = 'YOUR_PERPLEXITY_API_KEY_HERE';`

### 2. Analytics/Charts - View Progress ⚠️
- **Status:** NOT IMPLEMENTED
- **Issue:** "Analytics coming soon!" snackbar when clicked
- **Impact:** No weekly/monthly trend graphs, no burn vs intake comparison charts
- **Location:** Dashboard Quick Actions "View Progress" button
- **Files Affected:**
  - `dashboard_screen.dart` - Line 301: Shows snackbar instead of navigating
- **Missing Components:**
  - Weekly/Monthly calorie comparison charts
  - Progress toward goal visualization
  - Burn vs intake graph (planned in `docs/plan.md` Phase 4)
  - Trends analysis screen
  - `lib/features/analytics/` folder doesn't exist

### 3. Edit Profile Functionality ⚠️
- **Status:** NOT IMPLEMENTED
- **Issue:** "Edit Profile - Coming soon!" snackbar when clicked
- **Impact:** Users cannot update their profile information (weight, age, height, goal)
- **Location:** Settings Screen → Profile card
- **Files Affected:**
  - `settings_screen.dart` - Line 76: Shows snackbar instead of navigating
- **Missing Components:**
  - Edit Profile Screen
  - Update weight tracking
  - Update goal settings
  - Update personal information

### 4. Dark Theme / System Theme ⚠️
- **Status:** NOT IMPLEMENTED
- **Issue:** "Dark theme coming soon!" / "System theme coming soon!" snackbars
- **Impact:** Only Light theme works
- **Location:** Settings Screen → Theme Settings modal
- **Files Affected:**
  - `settings_screen.dart` - Lines 417, 428: Shows snackbar for dark/system themes
- **Missing Components:**
  - Dark theme color scheme
  - System theme preference detection
  - Theme switching logic in app root
  - ThemeMode state management

### 5. Health Connect Data Sync ⚠️
- **Status:** PARTIALLY IMPLEMENTED
- **Issue:** Permission dialog works, but actual data fetching not tested/validated
- **Impact:** May not retrieve steps/calories from Health Connect even with permissions
- **Location:** `lib/features/health/services/health_service.dart`
- **Requires Testing:**
  - Real device with Health Connect
  - Verify steps are fetched correctly
  - Verify calories burned calculation
  - Verify activity history retrieval

### 6. Daily AI Guidance ⚠️
- **Status:** NOT IMPLEMENTED
- **Issue:** No "What To Do Today" guidance system
- **Impact:** No personalized daily action recommendations
- **Location:** Not present in Dashboard (planned in `docs/plan.md` Phase 5)
- **Missing Components:**
  - Guidance algorithm (planned in `docs/plan.md`)
  - Daily action card on Dashboard
  - Progress-based recommendations
  - Notification system for guidance reminders
  - `lib/features/guidance/` folder doesn't exist

### 7. Meal History Details ⚠️
- **Status:** BASIC IMPLEMENTATION ONLY
- **Issue:** Shows meal list but no editing, deleting, or detailed meal info
- **Impact:** Users can only view meals, not modify or get detailed analysis
- **Location:** Meal History Screen
- **Files Affected:**
  - `meal_history_screen.dart` - Read-only view
- **Missing Features:**
  - Edit meal entry
  - Delete meal entry
  - View AI analysis breakdown for each meal
  - Meal categories/tagging

### 8. Activity History ⚠️
- **Status:** NOT IMPLEMENTED
- **Issue:** No dedicated activity history screen
- **Impact:** Users cannot view past activities logged, only meals
- **Location:** Missing from app
- **Missing Components:**
  - Activity history screen
  - Activity detail view
  - Activity editing/deletion
  - Activity statistics

### 9. Goal Progress Tracking ⚠️
- **Status:** NOT IMPLEMENTED
- **Issue:** No visual progress indicators toward user's goal
- **Impact:** Users cannot see how close they are to their weight/fitness goals
- **Location:** Dashboard (planned but not implemented)
- **Missing Components:**
  - Goal progress card/widget
  - Weight change tracking over time
  - Days remaining to goal calculation
  - Milestone celebrations

### 10. Weekly/Monthly Summaries ⚠️
- **Status:** NOT IMPLEMENTED
- **Issue:** No weekly or monthly data aggregation
- **Impact:** Users cannot see patterns over longer time periods
- **Location:** Missing from app
- **Missing Components:**
  - Weekly summary screen
  - Monthly summary screen
  - Streak tracking (consecutive days on track)
  - Best day / worst day analysis

### 11. Notification System (Push/Local) ⚠️
- **Status:** DATA MODEL ONLY
- **Issue:** NotificationProvider exists but no actual push/local notifications
- **Impact:** No reminder notifications for logging meals, activities, or daily guidance
- **Location:** `lib/shared/providers/notification_provider.dart`
- **Missing Components:**
  - Local notification scheduling (flutter_local_notifications package)
  - Push notification integration
  - Reminder scheduling
  - Notification preferences (time of day, frequency)

### 12. Onboarding: Daily Calorie Target Calculation ⚠️
- **Status:** HARDCODED
- **Issue:** dailyCalorieTarget set to 2000 for all users
- **Impact:** Not personalized based on user's goal, weight, height, age, gender
- **Location:** `profile_setup_screen.dart` - Line 54
- **Files Affected:**
  - `profile_setup_screen.dart` - `dailyCalorieTarget: 2000, // This will be calculated based on goal`
- **Required:**
  - BMR calculation (Basal Metabolic Rate)
  - TDEE calculation (Total Daily Energy Expenditure)
  - Goal-based adjustment (deficit for weight loss, surplus for gain)

### 13. UI Overflow on Some Devices ⚠️
- **Status:** REPORTED BUT NOT FIXED
- **Issue:** 75px overflow on Pixel 6 Pro
- **Impact:** UI may be cut off on certain device sizes
- **Location:** Potentially multiple screens
- **Files Affected:**
  - Unknown - needs physical device testing
- **Note:** Listed in `docs/tasks.md` as "needs physical device testing"

### 14. Export/Import Data ⚠️
- **Status:** NOT IMPLEMENTED
- **Issue:** No way to backup or transfer data
- **Impact:** Users lose all data if app uninstalled
- **Location:** Missing from Settings
- **Missing Components:**
  - Export to JSON/CSV
  - Import from file
  - Cloud backup integration

---

## 📊 SUMMARY STATISTICS

| Category | Count |
|----------|-------|
| ✅ Fixed/Working | 8 |
| ⚠️ Not Functional | 14 |
| 🔧 Partially Working | 2 |
| **Total Issues Identified** | **24** |

---

## 🎯 PRIORITY RECOMMENDATIONS

### HIGH PRIORITY (Core Functionality)
1. **Perplexity API Configuration** - Critical for meal logging
2. **Health Connect Data Sync Testing** - Verify permissions work end-to-end
3. **Daily Calorie Target Calculation** - Currently hardcoded, not personalized
4. **Edit Profile** - Users need to update weight as they progress

### MEDIUM PRIORITY (User Experience)
5. **Analytics/Charts (View Progress)** - Highly visible feature, marked "coming soon"
6. **Goal Progress Tracking** - Key motivational feature
7. **Dark Theme** - Common user expectation

### LOW PRIORITY (Nice to Have)
8. **AI Daily Guidance** - Future enhancement
9. **Weekly/Monthly Summaries** - Analytics enhancement
10. **Export/Import Data** - Power user feature

---

## 📝 NOTES

- Most core features are now functional after recent bug fixes
- The biggest gaps are in analytics/visualization and personalization
- API integration (Perplexity) is the main blocker for full meal analysis
- Theme switching and data management are common expectations but not critical

---

**Last Updated:** January 8, 2026
