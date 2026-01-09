class ActivityEntry {
  final String id;
  final String type; // 'walking', 'running', 'gym', 'sports', etc.
  final int durationMinutes;
  final int caloriesBurned;
  final DateTime timestamp;

  ActivityEntry({
    required this.id,
    required this.type,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.timestamp,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'durationMinutes': durationMinutes,
      'caloriesBurned': caloriesBurned,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Create from JSON
  factory ActivityEntry.fromJson(Map<String, dynamic> json) {
    return ActivityEntry(
      id: json['id'] as String,
      type: json['type'] as String,
      durationMinutes: json['durationMinutes'] as int,
      caloriesBurned: json['caloriesBurned'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  // Copy with method
  ActivityEntry copyWith({
    String? id,
    String? type,
    int? durationMinutes,
    int? caloriesBurned,
    DateTime? timestamp,
  }) {
    return ActivityEntry(
      id: id ?? this.id,
      type: type ?? this.type,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
