# HNotes - Technical Implementation Plan

This document provides detailed implementation instructions for building HNotes. Any developer or AI assistant can follow this plan to execute the project.

---

## Table of Contents
1. [Project Structure](#project-structure)
2. [Phase 0: Setup & Hello World](#phase-0-setup--hello-world)
3. [Phase 1: Core Architecture](#phase-1-core-architecture)
4. [Phase 2: Calorie Burn Tracking](#phase-2-calorie-burn-tracking)
5. [Phase 3: AI Calorie Intake](#phase-3-ai-calorie-intake)
6. [Phase 4: Dashboard & Analytics](#phase-4-dashboard--analytics)
7. [Phase 5: AI Daily Guidance](#phase-5-ai-daily-guidance)
8. [API Reference](#api-reference)

---

## Project Structure

```
hnotes/
├── android/                 # Android-specific code
├── ios/                     # iOS-specific code (future)
├── lib/
│   ├── main.dart           # App entry point
│   ├── app.dart            # App configuration
│   ├── core/
│   │   ├── constants/      # App constants, colors, strings
│   │   ├── theme/          # App theming
│   │   └── utils/          # Utility functions
│   ├── data/
│   │   ├── models/         # Data models
│   │   ├── repositories/   # Data repositories
│   │   └── services/       # API services
│   ├── features/
│   │   ├── onboarding/     # Onboarding screens
│   │   ├── dashboard/      # Main dashboard
│   │   ├── burn_tracking/  # Calorie burn feature
│   │   ├── intake_tracking/# Calorie intake feature
│   │   ├── analytics/      # Charts and graphs
│   │   └── guidance/       # Daily AI guidance
│   └── shared/
│       ├── widgets/        # Reusable widgets
│       └── providers/      # State providers
├── assets/
│   ├── images/
│   └── fonts/
├── docs/                   # Documentation
├── test/                   # Unit and widget tests
└── pubspec.yaml           # Dependencies
```

---

## Phase 0: Setup & Hello World

### Step 1: Install Flutter SDK

**Windows:**
```bash
# Download Flutter SDK from https://flutter.dev/docs/get-started/install/windows
# Extract to C:\flutter
# Add C:\flutter\bin to PATH environment variable

# Verify installation
flutter doctor
```

### Step 2: Install Android Studio
1. Download from https://developer.android.com/studio
2. Install with default settings
3. Open Android Studio → More Actions → SDK Manager
4. Install Android SDK, Android SDK Command-line Tools, Android SDK Build-Tools
5. Create an Android Virtual Device (AVD) for testing

### Step 3: Configure Flutter for Android
```bash
flutter config --android-studio-dir="C:\Program Files\Android\Android Studio"
flutter doctor --android-licenses  # Accept all licenses
flutter doctor  # Should show all green checkmarks
```

### Step 4: Create Hello World App
```bash
cd c:/Users/ChristianTonny/Downloads/Development
flutter create hnotes
cd hnotes
```

### Step 5: Modify main.dart for Assignment
Replace `lib/main.dart` with:

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HNotes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HelloWorldScreen(),
    );
  }
}

class HelloWorldScreen extends StatelessWidget {
  const HelloWorldScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HNotes'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hello World',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Christian Tonny',  // Replace with your actual name
              style: TextStyle(
                fontSize: 24,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Step 6: Run on Emulator/Device
```bash
# List available devices
flutter devices

# Run on connected device or emulator
flutter run

# Or specify device
flutter run -d <device_id>
```

### Step 7: Record Demo Video
1. Start screen recording (include date/time visible)
2. Show your face briefly for verification
3. Show the app running on emulator/device
4. Save video and upload to accessible location (Google Drive, YouTube unlisted)

### Step 8: Create PDF Submission
Include:
- Any errors encountered during setup and their solutions
- Working link to demo video
- Screenshots if helpful

---

## Phase 1: Core Architecture

### Dependencies (pubspec.yaml)
```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  provider: ^6.1.1

  # Backend & Storage
  convex_flutter: ^0.1.0

  # Charts
  fl_chart: ^0.66.0

  # HTTP
  http: ^1.2.0

  # Health Data
  health: ^10.0.0
  permission_handler: ^11.1.0

  # UI
  google_fonts: ^6.1.0
  flutter_animate: ^4.3.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  hive_generator: ^2.0.1
  build_runner: ^2.4.8
```

### Data Models

**lib/data/models/user_profile.dart:**
```dart
class UserProfile {
  final String name;
  final double goalWeight;
  final double currentWeight;
  final String goal; // 'lose_weight', 'build_muscle', 'maintain'
  final int dailyCalorieTarget;
  final DateTime createdAt;

  UserProfile({
    required this.name,
    required this.goalWeight,
    required this.currentWeight,
    required this.goal,
    required this.dailyCalorieTarget,
    required this.createdAt,
  });
}
```

**lib/data/models/daily_log.dart:**
```dart
class DailyLog {
  final DateTime date;
  final int caloriesBurned;
  final int caloriesConsumed;
  final int steps;
  final List<MealEntry> meals;
  final List<ActivityEntry> activities;

  DailyLog({
    required this.date,
    required this.caloriesBurned,
    required this.caloriesConsumed,
    required this.steps,
    required this.meals,
    required this.activities,
  });

  int get calorieBalance => caloriesBurned - caloriesConsumed;
}
```

**lib/data/models/meal_entry.dart:**
```dart
class MealEntry {
  final String id;
  final String description; // Natural language input
  final int calories;
  final DateTime timestamp;
  final String? aiAnalysis;

  MealEntry({
    required this.id,
    required this.description,
    required this.calories,
    required this.timestamp,
    this.aiAnalysis,
  });
}
```

---

## Phase 2: Calorie Burn Tracking

### Android Configuration

**android/app/src/main/AndroidManifest.xml:**
Add inside `<manifest>`:
```xml
<uses-permission android:name="android.permission.ACTIVITY_RECOGNITION"/>
<uses-permission android:name="android.permission.health.READ_STEPS"/>
<uses-permission android:name="android.permission.health.READ_TOTAL_CALORIES_BURNED"/>
```

### Health Service

**lib/data/services/health_service.dart:**
```dart
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class HealthService {
  final HealthFactory _health = HealthFactory();

  static const List<HealthDataType> _types = [
    HealthDataType.STEPS,
    HealthDataType.ACTIVE_ENERGY_BURNED,
  ];

  Future<bool> requestPermissions() async {
    // Request activity recognition permission
    await Permission.activityRecognition.request();

    // Request Health Connect permissions
    return await _health.requestAuthorization(_types);
  }

  Future<int> getTodaySteps() async {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    final steps = await _health.getTotalStepsInInterval(midnight, now);
    return steps ?? 0;
  }

  Future<double> getTodayCaloriesBurned() async {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    final data = await _health.getHealthDataFromTypes(
      midnight,
      now,
      [HealthDataType.ACTIVE_ENERGY_BURNED],
    );

    double total = 0;
    for (var point in data) {
      total += (point.value as num).toDouble();
    }
    return total;
  }
}
```

### Calorie Calculation Formula
```dart
// Base Metabolic Rate (simplified)
double calculateBMR(double weightKg, double heightCm, int age, bool isMale) {
  if (isMale) {
    return 88.362 + (13.397 * weightKg) + (4.799 * heightCm) - (5.677 * age);
  } else {
    return 447.593 + (9.247 * weightKg) + (3.098 * heightCm) - (4.330 * age);
  }
}

// Calories burned from steps (approximate)
double caloriesFromSteps(int steps, double weightKg) {
  // Average: 0.04 calories per step per kg of body weight
  return steps * 0.04 * (weightKg / 70);
}
```

---

## Phase 3: AI Calorie Intake

### Perplexity Sonar API Integration

**lib/data/services/ai_service.dart:**
```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String _baseUrl = 'https://api.perplexity.ai';
  final String _apiKey;

  AIService(this._apiKey);

  Future<MealAnalysis> analyzeMeal(String description) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/chat/completions'),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'sonar',
        'messages': [
          {
            'role': 'system',
            'content': '''You are a nutrition expert. Analyze the food described
            and return a JSON object with:
            - calories: estimated total calories (integer)
            - breakdown: brief description of the meal components
            - confidence: "high", "medium", or "low"
            Be concise and accurate.'''
          },
          {
            'role': 'user',
            'content': 'Analyze this meal: $description'
          }
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data['choices'][0]['message']['content'];
      return MealAnalysis.fromJson(jsonDecode(content));
    } else {
      throw Exception('Failed to analyze meal');
    }
  }
}

class MealAnalysis {
  final int calories;
  final String breakdown;
  final String confidence;

  MealAnalysis({
    required this.calories,
    required this.breakdown,
    required this.confidence,
  });

  factory MealAnalysis.fromJson(Map<String, dynamic> json) {
    return MealAnalysis(
      calories: json['calories'] as int,
      breakdown: json['breakdown'] as String,
      confidence: json['confidence'] as String,
    );
  }
}
```

### Natural Language Input UI

**lib/features/intake_tracking/widgets/meal_input.dart:**
```dart
class MealInputWidget extends StatefulWidget {
  final Function(MealEntry) onMealAdded;

  const MealInputWidget({required this.onMealAdded, super.key});

  @override
  State<MealInputWidget> createState() => _MealInputWidgetState();
}

class _MealInputWidgetState extends State<MealInputWidget> {
  final _controller = TextEditingController();
  bool _isAnalyzing = false;

  Future<void> _analyzeMeal() async {
    if (_controller.text.isEmpty) return;

    setState(() => _isAnalyzing = true);

    try {
      final analysis = await context.read<AIService>().analyzeMeal(
        _controller.text,
      );

      final meal = MealEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        description: _controller.text,
        calories: analysis.calories,
        timestamp: DateTime.now(),
        aiAnalysis: analysis.breakdown,
      );

      widget.onMealAdded(meal);
      _controller.clear();
    } finally {
      setState(() => _isAnalyzing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'What did you eat? (e.g., "chicken sandwich and coffee")',
            suffixIcon: _isAnalyzing
                ? const CircularProgressIndicator()
                : IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _analyzeMeal,
                  ),
          ),
        ),
      ],
    );
  }
}
```

---

## Phase 4: Dashboard & Analytics

### Main Dashboard Layout

**lib/features/dashboard/screens/dashboard_screen.dart:**
```dart
class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Today's Action Card (Most prominent)
              TodayActionCard(),

              const SizedBox(height: 24),

              // Burn vs Intake Summary
              CalorieBalanceCard(),

              const SizedBox(height: 16),

              // Quick Stats Row
              Row(
                children: [
                  Expanded(child: BurnedCard()),
                  const SizedBox(width: 12),
                  Expanded(child: ConsumedCard()),
                ],
              ),

              const SizedBox(height: 24),

              // Weekly Graph
              WeeklyChartCard(),

              const SizedBox(height: 16),

              // Progress Toward Goal
              GoalProgressCard(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showMealInput(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

### Burn vs Intake Graph

**lib/features/analytics/widgets/calorie_chart.dart:**
```dart
import 'package:fl_chart/fl_chart.dart';

class CalorieComparisonChart extends StatelessWidget {
  final List<DailyLog> weekData;

  const CalorieComparisonChart({required this.weekData, super.key});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barGroups: weekData.asMap().entries.map((entry) {
          final index = entry.key;
          final log = entry.value;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: log.caloriesBurned.toDouble(),
                color: Colors.green,
                width: 12,
              ),
              BarChartRodData(
                toY: log.caloriesConsumed.toDouble(),
                color: Colors.orange,
                width: 12,
              ),
            ],
          );
        }).toList(),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                return Text(days[value.toInt() % 7]);
              },
            ),
          ),
        ),
      ),
    );
  }
}
```

---

## Phase 5: AI Daily Guidance

### Guidance Algorithm

**lib/data/services/guidance_service.dart:**
```dart
class GuidanceService {
  String generateDailyAction(DailyLog today, UserProfile profile) {
    final balance = today.calorieBalance;
    final targetDeficit = profile.goal == 'lose_weight' ? 500 : 0;
    final currentDeficit = today.caloriesBurned - today.caloriesConsumed;

    // If behind on goal
    if (currentDeficit < targetDeficit - 200) {
      final needed = targetDeficit - currentDeficit;
      if (needed > 300) {
        return "Take a 30-minute walk to burn ${(needed * 0.5).round()} more calories";
      } else if (needed > 100) {
        return "A 15-minute walk after dinner will get you back on track";
      } else {
        return "Skip the evening snack to hit your goal";
      }
    }

    // If on track
    if (currentDeficit >= targetDeficit - 50 && currentDeficit <= targetDeficit + 100) {
      return "You're on track today! Keep it up";
    }

    // If ahead of goal
    if (currentDeficit > targetDeficit + 100) {
      return "Great work! You've exceeded your goal by ${currentDeficit - targetDeficit} calories";
    }

    return "Log your next meal to see personalized guidance";
  }

  String generateProgressMessage(UserProfile profile, List<DailyLog> history) {
    final daysOnTrack = history.where((log) {
      final deficit = log.caloriesBurned - log.caloriesConsumed;
      return deficit >= 400; // Approximate target
    }).length;

    final totalDays = history.length;
    final percentage = (daysOnTrack / totalDays * 100).round();

    return "You've been on track $daysOnTrack of the last $totalDays days ($percentage%)";
  }
}
```

---

## API Reference

### Perplexity Sonar API
- **Endpoint**: `https://api.perplexity.ai/chat/completions`
- **Auth**: Bearer token in header
- **Model**: `sonar` (fast, cost-effective)
- **Rate Limits**: Check current documentation

### Android Health Connect
- **Package**: `health: ^10.0.0`
- **Permissions Required**:
  - `android.permission.ACTIVITY_RECOGNITION`
  - Health Connect specific permissions
- **Data Types Used**:
  - `STEPS`
  - `ACTIVE_ENERGY_BURNED`

---

## Environment Variables

Create `.env` file (DO NOT commit to git):
```
PERPLEXITY_API_KEY=your_api_key_here
```

Add to `.gitignore`:
```
.env
*.env
```

---

## Testing Strategy

1. **Unit Tests**: Test calculation functions, data models
2. **Widget Tests**: Test UI components in isolation
3. **Integration Tests**: Test full user flows
4. **Manual Testing**: Test on real device with actual health data

---

## Deployment Checklist

- [ ] Remove debug flags
- [ ] Secure API keys
- [ ] Test on multiple device sizes
- [ ] Test with real health data
- [ ] Performance profiling
- [ ] Create release build
- [ ] Generate signed APK
