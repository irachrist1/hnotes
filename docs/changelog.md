# HNotes - Changelog

## Version 0.2.0 - January 8, 2026

### ✨ Major Improvements

#### 1. **Color Consistency Fixed**
- ✅ All onboarding screens now use the same blue gradient (#1F3DBD → #1792DB)
- ✅ Welcome, Goal Selection, and Profile Setup all match
- ✅ White text on gradient for better readability
- ✅ Consistent button styling (white buttons with blue text)

#### 2. **State Management Implemented**
- ✅ Added Provider package for state management
- ✅ Created `UserProvider` - manages user profile with persistence
- ✅ Created `DailyLogProvider` - manages daily activity logs
- ✅ All data saves to SharedPreferences automatically
- ✅ Splash screen checks onboarding status on app startup

#### 3. **Smart Input Pickers**
- ✅ Replaced text fields with iOS-style wheel pickers
- ✅ Age picker: 13-100 years
- ✅ Height picker: 120-220 cm
- ✅ Weight pickers: 30-200 kg
- ✅ Smooth scrolling with haptic feedback
- ✅ Beautiful bottom sheet modal design

#### 4. **Data Persistence**
- ✅ User profile saves when completing onboarding
- ✅ Data persists when app closes
- ✅ Splash screen loads saved data on startup
- ✅ Dashboard shows user's name and saved data
- ✅ No more data loss on app restart!

#### 5. **Improved User Experience**
- ✅ Splash screen with loading indicator
- ✅ Automatic routing based on onboarding status
- ✅ Better form validation with helpful error messages
- ✅ Smooth animations throughout

### 🔧 Technical Changes

**New Files Created:**
- `lib/shared/providers/user_provider.dart`
- `lib/shared/providers/daily_log_provider.dart`
- `lib/shared/widgets/number_picker_field.dart`

**Updated Files:**
- `lib/main.dart` - Added Provider integration and splash screen
- `lib/features/onboarding/screens/goal_selection_screen.dart` - Gradient background
- `lib/features/onboarding/screens/profile_setup_screen.dart` - Pickers + persistence
- `pubspec.yaml` - Added permission_handler dependency

**New Dependencies:**
- `permission_handler: ^11.1.0` (for health permissions in next phase)

### 🎨 UI Improvements

- Gradient backgrounds on all onboarding screens
- White text overlays for better contrast
- Input pickers with scroll wheel interaction
- Consistent button styling throughout
- Better spacing and padding

### 📱 App Flow

1. **Splash Screen** → Loads user data
2. **Welcome** (if new user) or **Dashboard** (if returning user)
3. **Goal Selection** → User picks their fitness goal
4. **Profile Setup** → User enters details with pickers
5. **Dashboard** → Personalized home screen

### 🐛 Fixes

- Fixed MultiProvider empty children error
- Fixed color inconsistency across onboarding
- Fixed data not persisting on app close
- Improved form validation

### 📋 Still To Do

- [ ] Fix UI overflow on Pixel 6 Pro (75px) - needs testing on larger devices
- [ ] Add health permissions request flow
- [ ] Integrate Android Health Connect for real step data
- [ ] Add Perplexity AI API for meal calorie calculation
- [ ] Implement charts and analytics

### 🎯 Next Priority

**Health Permissions Flow:**
- Add permissions screen after onboarding
- Request activity recognition permission
- Request health data access
- Guide user through Health Connect setup

---

## Version 0.1.0 - January 7, 2026

### Initial Release
- Basic app structure
- Onboarding screens (Welcome, Goal, Profile)
- Dashboard UI
- Data models
- Theme configuration
- Hello World functionality
