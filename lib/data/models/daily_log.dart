import 'meal_entry.dart';
import 'activity_entry.dart';

class DailyLog {
  final String id;
  final DateTime date;
  final int caloriesBurned;
  final int caloriesConsumed;
  final int steps;
  final List<MealEntry> meals;
  final List<ActivityEntry> activities;

  DailyLog({
    required this.id,
    required this.date,
    required this.caloriesBurned,
    required this.caloriesConsumed,
    required this.steps,
    required this.meals,
    required this.activities,
  });

  // Calculate calorie balance (positive = surplus, negative = deficit)
  int get calorieBalance => caloriesBurned - caloriesConsumed;

  // Check if on track (assuming 500 calorie deficit goal for weight loss)
  bool get isOnTrack => calorieBalance >= 400 && calorieBalance <= 600;

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'caloriesBurned': caloriesBurned,
      'caloriesConsumed': caloriesConsumed,
      'steps': steps,
      'meals': meals.map((m) => m.toJson()).toList(),
      'activities': activities.map((a) => a.toJson()).toList(),
    };
  }

  // Create from JSON
  factory DailyLog.fromJson(Map<String, dynamic> json) {
    return DailyLog(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      caloriesBurned: json['caloriesBurned'] as int,
      caloriesConsumed: json['caloriesConsumed'] as int,
      steps: json['steps'] as int,
      meals: (json['meals'] as List)
          .map((m) => MealEntry.fromJson(m as Map<String, dynamic>))
          .toList(),
      activities: (json['activities'] as List)
          .map((a) => ActivityEntry.fromJson(a as Map<String, dynamic>))
          .toList(),
    );
  }

  // Copy with method
  DailyLog copyWith({
    String? id,
    DateTime? date,
    int? caloriesBurned,
    int? caloriesConsumed,
    int? steps,
    List<MealEntry>? meals,
    List<ActivityEntry>? activities,
  }) {
    return DailyLog(
      id: id ?? this.id,
      date: date ?? this.date,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      caloriesConsumed: caloriesConsumed ?? this.caloriesConsumed,
      steps: steps ?? this.steps,
      meals: meals ?? this.meals,
      activities: activities ?? this.activities,
    );
  }

  // Create empty log for a given date
  factory DailyLog.empty(DateTime date) {
    return DailyLog(
      id: date.millisecondsSinceEpoch.toString(),
      date: date,
      caloriesBurned: 0,
      caloriesConsumed: 0,
      steps: 0,
      meals: [],
      activities: [],
    );
  }
}
