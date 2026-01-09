class MealEntry {
  final String id;
  final String description; // Natural language input (e.g., "chicken sandwich and coffee")
  final int calories;
  final DateTime timestamp;
  final String? aiAnalysis; // AI breakdown of the meal

  MealEntry({
    required this.id,
    required this.description,
    required this.calories,
    required this.timestamp,
    this.aiAnalysis,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'calories': calories,
      'timestamp': timestamp.toIso8601String(),
      'aiAnalysis': aiAnalysis,
    };
  }

  // Create from JSON
  factory MealEntry.fromJson(Map<String, dynamic> json) {
    return MealEntry(
      id: json['id'] as String,
      description: json['description'] as String,
      calories: json['calories'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
      aiAnalysis: json['aiAnalysis'] as String?,
    );
  }

  // Copy with method
  MealEntry copyWith({
    String? id,
    String? description,
    int? calories,
    DateTime? timestamp,
    String? aiAnalysis,
  }) {
    return MealEntry(
      id: id ?? this.id,
      description: description ?? this.description,
      calories: calories ?? this.calories,
      timestamp: timestamp ?? this.timestamp,
      aiAnalysis: aiAnalysis ?? this.aiAnalysis,
    );
  }
}
