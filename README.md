# HNotes - Health & Nutrition Tracking App

A comprehensive Flutter application for tracking meals, activities, and health data with AI-powered meal analysis and Health Connect integration.

## ✅ Current Status: FULLY FUNCTIONAL

All core features are implemented and working. The app is ready for use with optional configuration for enhanced features.

## 🎯 Features

### Core Functionality
- ✅ **Complete Onboarding Flow**: Welcome → Goal Selection → Profile Setup → Health Permissions
- ✅ **Dashboard**: Real-time health stats with AI-powered daily recommendations
- ✅ **Meal Logging**: Natural language input with AI calorie estimation
- ✅ **Activity Tracking**: 8 predefined activities with calorie burn calculation
- ✅ **Meal History**: View last 7 days of logged meals grouped by date
- ✅ **Settings**: Edit profile, update weight goals, manage permissions
- ✅ **Notifications**: In-app notification system
- ✅ **Data Persistence**: All data saved locally using SharedPreferences
- ✅ **Health Connect Integration**: Step counting and calorie burn tracking

### UI/UX
- ✅ Gradient AppBars with white text
- ✅ Gradient buttons (Analyze Meal, Log Activity)
- ✅ Smooth animations with flutter_animate
- ✅ Consistent color scheme throughout
- ✅ Empty states for all lists
- ✅ Loading indicators during async operations

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (^3.10.4)
- Dart SDK
- Android Studio / VS Code
- Android device or emulator (API 26+)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd hnotes
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## ⚙️ Configuration

### Optional: Perplexity AI Integration

For enhanced meal analysis with AI, configure your Perplexity API key:

1. Get an API key from [Perplexity AI](https://www.perplexity.ai/settings/api)
2. Open `lib/features/intake_tracking/services/perplexity_service.dart`
3. Replace `YOUR_PERPLEXITY_API_KEY_HERE` with your actual API key

**Note:** The app includes a keyword-based fallback estimation system, so it works perfectly fine without the API key configured!

### Health Connect Setup (Android Only)

1. Ensure your device has Health Connect installed
2. Grant activity recognition permissions when prompted
3. Grant Health Connect permissions for step counting
4. The app will automatically sync step data on dashboard load

**Note:** Health Connect permissions can be skipped during onboarding - the app will still function normally.

## 📱 App Flow

### First Launch
1. **Welcome Screen**: Introduction to HNotes
2. **Goal Selection**: Choose from 4 health goals (Lose Weight, Build Muscle, Stay Healthy, Improve Energy)
3. **Profile Setup**: Enter name, age, height, weight, gender
4. **Health Permissions**: Grant or skip Health Connect access
5. **Dashboard**: Start tracking!

### Daily Use
1. **Dashboard**: View daily stats and AI recommendations
2. **Log Meal**: Describe what you ate in natural language
   - Example: "2 eggs, toast, and coffee for breakfast"
   - AI estimates calories automatically
3. **Log Activity**: Select activity type and duration (8 activity types available)
4. **View History**: Check past meals in Meal History
5. **Adjust Settings**: Update weight, goals, or preferences

## 🏗️ Architecture

### State Management
- **Provider pattern** for state management
- Three main providers: `UserProvider`, `DailyLogProvider`, `NotificationProvider`

### Data Persistence
- **SharedPreferences** for local data storage
- JSON serialization for complex objects
- Automatic save on all data changes

## 📝 Key Features Details

### 1. Meal Logging System
- **Input**: Natural language meal description
- **Processing**: Perplexity AI analysis (if configured) OR keyword-based estimation (fallback)
- **Storage**: Saved to daily log with timestamp

### 2. Activity Tracking
- **8 Activity Types**: Walking, Running, Cycling, Gym, Swimming, Yoga, Sports, Other
- **Duration**: 5-120 minutes (adjustable slider)
- **Calculation**: Real-time calorie burn estimation

### 3. Health Connect Integration
- **Step Counting**: Automatic daily step retrieval
- **Calorie Calculation**: BMR + step-based active calories
- **Auto-Sync**: Dashboard refreshes health data on load
- **Graceful Degradation**: Works without permissions

### 4. AI Recommendations
- **Goal-Specific**: Different recommendations for Weight Loss, Muscle Building, Maintenance, Energy Improvement
- **Dynamic**: Updates based on real-time data

### 5. Settings Management
- ✅ Edit Profile, Update Weights, Health Permissions, Theme, Notifications, Privacy Policy, Logout

## 🐛 Known Limitations

1. **Deprecation Warnings**: 64 instances of `withOpacity()` deprecation - cosmetic only, doesn't affect functionality
2. **Health Connect**: Android only, requires real device for full testing
3. **Perplexity API**: Requires paid API key, but fallback system works without it

## 🔮 Future Enhancements

- iOS HealthKit integration
- Charts and progress visualization
- Meal photo recognition
- Dark mode
- Multi-language support

---

**Built with ❤️ using Flutter**

