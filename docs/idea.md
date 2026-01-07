# HNotes - AI-Powered Health & Fitness Companion

## Vision
HNotes is an all-in-one health application designed to help busy people achieve their fitness goals without disrupting their lifestyle. Unlike complex fitness apps, HNotes is **simple, actionable, and AI-driven** - it tells you exactly what to do each day to reach your goals.

## Core Problem We're Solving
Everyone sets New Year's resolutions to lose weight and get fit, but schedules don't allow for traditional workout routines. HNotes solves this by:
- Finding small exercise opportunities within your existing schedule
- Tracking everything automatically in the background
- Giving you one simple action each time you open the app

## Inspiration
- **Whoop Band**: Goal-oriented fitness tracking with AI insights
- **Simplicity First**: Unlike Whoop's complexity, HNotes is minimal and actionable

---

## Core Features

### 1. Smart Goal Setting (Onboarding)
- Ask simple questions about user's goals (lose weight, build muscle, improve energy)
- Understand their schedule and lifestyle
- AI creates a personalized plan that fits their life

### 2. Calorie Burn Tracking
- **Data Sources**:
  - Android Health Connect API (steps, heart rate, workouts)
  - Smartwatch integration (Wear OS, Samsung Health)
  - Manual activity logging
- **Displays**:
  - Daily calories burned
  - Weekly/monthly trends
  - Activity breakdown (walking, exercise, resting)

### 3. Calorie Intake Tracking (AI-Powered)
- **Natural Language Input**: Type "I had a chicken sandwich and coffee" and AI calculates calories
- **API**: Perplexity Sonar API for food recognition and calorie estimation
- **Future Feature**: Photo analysis of food for automatic calorie detection
- **Displays**:
  - Daily intake vs. goal
  - Meal history
  - Nutritional insights

### 4. Burn vs. Intake Dashboard
- Visual graph comparing calories burned vs. consumed
- Daily calorie balance (deficit or surplus)
- Progress toward goal visualization
- Simple, glanceable metrics

### 5. Daily Action Guidance
- **"What To Do Today"**: One clear action when you open the app
- Examples:
  - "Take a 10-minute walk after lunch to burn 50 more calories"
  - "You're 200 calories over - skip the evening snack"
  - "Great job! You're on track. Keep it up!"
- AI adapts recommendations based on your progress

### 6. Progress Tracking
- Daily check-ins: "You're X days closer to your goal"
- Weekly summaries
- Milestone celebrations
- Trend analysis

---

## Technical Stack

| Component | Technology |
|-----------|------------|
| Framework | Flutter (Dart) |
| AI API | Perplexity Sonar API |
| Health Data | Android Health Connect API |
| State Management | Provider or Riverpod |
| Charts | fl_chart package |

---

## User Experience Principles

1. **One Glance**: All important info visible without scrolling
2. **One Action**: Tell users ONE thing to do, not a list
3. **Zero Friction**: Natural language for everything
4. **Automatic**: Background tracking, minimal manual input
5. **Encouraging**: Positive reinforcement, not guilt

---

## Future Features (Post-MVP)
- Photo-based food calorie detection
- Social accountability features
- Integration with more wearables
- Workout video suggestions
- Sleep tracking integration
- Hydration tracking
- iOS version

---

## Success Metrics
- User opens app daily
- User logs at least one meal per day
- User completes suggested daily action
- User progresses toward their goal
