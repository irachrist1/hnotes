# Claude Code Rules for HNotes Project

## CRITICAL RULES - MUST FOLLOW

### 1. Widget Tree Bracket Matching
**NEVER** leave mismatched brackets in Dart widget trees.

When modifying a `build()` method or any nested widget structure:
1. **Count opening brackets** `(`, `[`, `{` 
2. **Count closing brackets** `)`, `]`, `}`
3. **They MUST match exactly**

Example structure that MUST be maintained:
```dart
return Scaffold(           // Opens (
  body: SafeArea(          //   Opens (
    child: Column(         //     Opens (
      children: [          //       Opens [
        Widget1(),         //         
        Widget2(),         //
      ],                   //       Closes ]
    ),                     //     Closes )
  ),                       //   Closes )
);                         // Closes )
```

### 2. When Editing Widget Trees
- **ALWAYS** read the entire `build()` method before editing
- **NEVER** add extra closing brackets `)` when wrapping widgets
- **ALWAYS** run `dart format` after editing
- **ALWAYS** verify with `flutter analyze` before completing

### 3. AppBar Styling Rules for This Project
- **Blue AppBar with white text** - Use solid color, NOT gradient on whole page
- Standard pattern:
```dart
appBar: AppBar(
  title: const Text('Title'),
  backgroundColor: AppColors.skyBlue,
  foregroundColor: Colors.white,
  elevation: 0,
),
body: SafeArea(...),  // Normal white body
```

### 4. Gradient Backgrounds - ONLY for Onboarding
The blue gradient (`AppColors.blueGradient`) should ONLY be used on:
- Welcome Screen
- Goal Selection Screen  
- Profile Setup Screen
- Health Permissions Screen

**NOT on:**
- Log Meal
- Log Activity
- Meal History
- Settings
- Notifications
- Dashboard

### 5. Verification Checklist
Before completing ANY Dart file edit:
- [ ] Run `dart format <file>`
- [ ] Run `flutter analyze --no-fatal-infos`
- [ ] Verify 0 errors in output
- [ ] Only then report success

### 6. Common Mistakes to Avoid
1. Adding `Container` wrapper but forgetting to close it
2. Adding `SafeArea` wrapper but creating duplicate closings
3. Changing `body:` to `body: Container(` without proper closing
4. Indentation drift causing bracket misalignment

### 7. If Build Fails with Bracket Errors
1. **DO NOT** make incremental fixes
2. **DO** read the entire method
3. **DO** rewrite the complete method if needed
4. Verify bracket count matches before saving
