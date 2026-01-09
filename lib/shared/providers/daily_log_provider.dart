import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/daily_log.dart';
import '../../data/models/meal_entry.dart';
import '../../data/models/activity_entry.dart';
import '../../features/health/services/health_service.dart';

class DailyLogProvider with ChangeNotifier {
  DailyLog? _todayLog;
  Map<String, DailyLog> _logs = {}; // Date string as key
  final HealthService _healthService = HealthService();

  DailyLog get todayLog {
    final today = DateTime.now();
    final todayKey = _getDateKey(today);

    if (_todayLog == null || _getDateKey(_todayLog!.date) != todayKey) {
      _todayLog = _logs[todayKey] ?? DailyLog.empty(today);
    }

    return _todayLog!;
  }

  Map<String, DailyLog> get allLogs => _logs;

  // Generate date key (YYYY-MM-DD)
  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Load all logs from storage
  Future<void> loadLogs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final logsString = prefs.getString('daily_logs');

      if (logsString != null) {
        final logsData = jsonDecode(logsString) as Map<String, dynamic>;
        _logs = logsData.map(
          (key, value) => MapEntry(
            key,
            DailyLog.fromJson(value as Map<String, dynamic>),
          ),
        );

        // Initialize today's log
        final today = DateTime.now();
        final todayKey = _getDateKey(today);
        _todayLog = _logs[todayKey] ?? DailyLog.empty(today);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading logs: $e');
    }
  }

  // Save logs to storage
  Future<void> _saveLogs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final logsData = _logs.map((key, log) => MapEntry(key, log.toJson()));
      final logsString = jsonEncode(logsData);
      await prefs.setString('daily_logs', logsString);
    } catch (e) {
      debugPrint('Error saving logs: $e');
    }
  }

  // Add meal entry
  Future<void> addMeal(MealEntry meal) async {
    final todayKey = _getDateKey(DateTime.now());
    final currentLog = todayLog;

    final updatedMeals = List<MealEntry>.from(currentLog.meals)..add(meal);
    final updatedCaloriesConsumed = currentLog.caloriesConsumed + meal.calories;

    final updatedLog = currentLog.copyWith(
      meals: updatedMeals,
      caloriesConsumed: updatedCaloriesConsumed,
    );

    _logs[todayKey] = updatedLog;
    _todayLog = updatedLog;

    notifyListeners();
    await _saveLogs();
  }

  // Add activity
  Future<void> addActivity(ActivityEntry activity) async {
    final todayKey = _getDateKey(DateTime.now());
    final currentLog = todayLog;

    final updatedActivities = List<ActivityEntry>.from(currentLog.activities)
      ..add(activity);
    final updatedCaloriesBurned =
        currentLog.caloriesBurned + activity.caloriesBurned;

    final updatedLog = currentLog.copyWith(
      activities: updatedActivities,
      caloriesBurned: updatedCaloriesBurned,
    );

    _logs[todayKey] = updatedLog;
    _todayLog = updatedLog;

    notifyListeners();
    await _saveLogs();
  }

  // Update steps count
  Future<void> updateSteps(int steps) async {
    final todayKey = _getDateKey(DateTime.now());
    final currentLog = todayLog;

    final updatedLog = currentLog.copyWith(steps: steps);

    _logs[todayKey] = updatedLog;
    _todayLog = updatedLog;

    notifyListeners();
    await _saveLogs();
  }

  // Update calories burned
  Future<void> updateCaloriesBurned(int calories) async {
    final todayKey = _getDateKey(DateTime.now());
    final currentLog = todayLog;

    final updatedLog = currentLog.copyWith(caloriesBurned: calories);

    _logs[todayKey] = updatedLog;
    _todayLog = updatedLog;

    notifyListeners();
    await _saveLogs();
  }

  // Get logs for date range (for charts)
  List<DailyLog> getLogsForRange(DateTime start, DateTime end) {
    final logs = <DailyLog>[];
    var current = start;

    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      final key = _getDateKey(current);
      logs.add(_logs[key] ?? DailyLog.empty(current));
      current = current.add(const Duration(days: 1));
    }

    return logs;
  }

  // Sync health data from Health Connect
  Future<void> syncHealthData({required double bmr}) async {
    try {
      // Check if we have permissions first
      final hasPermissions = await _healthService.hasPermissions();
      if (!hasPermissions) {
        debugPrint('No health permissions granted');
        return;
      }

      final today = DateTime.now();
      final todayKey = _getDateKey(today);
      final currentLog = todayLog;

      // Fetch steps from Health Connect
      final steps = await _healthService.getStepsForDate(today);

      // Calculate calories burned from steps using BMR
      final caloriesBurned = _healthService.calculateCaloriesFromSteps(steps, bmr);

      // Update the log
      final updatedLog = currentLog.copyWith(
        steps: steps,
        caloriesBurned: caloriesBurned.toInt(),
      );

      _logs[todayKey] = updatedLog;
      _todayLog = updatedLog;

      notifyListeners();
      await _saveLogs();

      debugPrint('Synced health data: $steps steps, ${caloriesBurned.toInt()} calories');
    } catch (e) {
      debugPrint('Error syncing health data: $e');
    }
  }

  // Clear all data
  Future<void> clearAllLogs() async {
    _logs = {};
    _todayLog = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('daily_logs');
  }
}
