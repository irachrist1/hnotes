class UserProfile {
  final String id;
  final String name;
  final double goalWeight;
  final double currentWeight;
  final double heightCm;
  final int age;
  final bool isMale;
  final String goal; // 'lose_weight', 'build_muscle', 'maintain', 'improve_energy'
  final int dailyCalorieTarget;
  final DateTime createdAt;

  UserProfile({
    required this.id,
    required this.name,
    required this.goalWeight,
    required this.currentWeight,
    required this.heightCm,
    required this.age,
    required this.isMale,
    required this.goal,
    required this.dailyCalorieTarget,
    required this.createdAt,
  });

  // Calculate BMR (Basal Metabolic Rate)
  double get bmr {
    if (isMale) {
      return 88.362 + (13.397 * currentWeight) + (4.799 * heightCm) - (5.677 * age);
    } else {
      return 447.593 + (9.247 * currentWeight) + (3.098 * heightCm) - (4.330 * age);
    }
  }

  // Calculate target calorie deficit for weight loss (500 cal/day = 1lb/week)
  int get targetDeficit {
    switch (goal) {
      case 'lose_weight':
        return 500;
      case 'build_muscle':
        return -200; // Slight surplus
      case 'maintain':
        return 0;
      default:
        return 0;
    }
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'goalWeight': goalWeight,
      'currentWeight': currentWeight,
      'heightCm': heightCm,
      'age': age,
      'isMale': isMale,
      'goal': goal,
      'dailyCalorieTarget': dailyCalorieTarget,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create from JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      goalWeight: (json['goalWeight'] as num).toDouble(),
      currentWeight: (json['currentWeight'] as num).toDouble(),
      heightCm: (json['heightCm'] as num).toDouble(),
      age: json['age'] as int,
      isMale: json['isMale'] as bool,
      goal: json['goal'] as String,
      dailyCalorieTarget: json['dailyCalorieTarget'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  // Copy with method for updates
  UserProfile copyWith({
    String? id,
    String? name,
    double? goalWeight,
    double? currentWeight,
    double? heightCm,
    int? age,
    bool? isMale,
    String? goal,
    int? dailyCalorieTarget,
    DateTime? createdAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      goalWeight: goalWeight ?? this.goalWeight,
      currentWeight: currentWeight ?? this.currentWeight,
      heightCm: heightCm ?? this.heightCm,
      age: age ?? this.age,
      isMale: isMale ?? this.isMale,
      goal: goal ?? this.goal,
      dailyCalorieTarget: dailyCalorieTarget ?? this.dailyCalorieTarget,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
