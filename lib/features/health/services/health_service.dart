import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class HealthService {
  final Health _health = Health();
  bool _isConfigured = false;

  // Define the types of health data we want to access
  static final List<HealthDataType> _healthDataTypes = [
    HealthDataType.STEPS,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.DISTANCE_DELTA,
  ];

  // Configure Health Connect - MUST be called before any other Health operations
  Future<void> _ensureConfigured() async {
    if (!_isConfigured) {
      await _health.configure();
      _isConfigured = true;
    }
  }

  // Request necessary permissions
  Future<bool> requestPermissions() async {
    // Configure Health Connect first
    await _ensureConfigured();
    
    // Request activity recognition permission first (Android)
    final activityStatus = await Permission.activityRecognition.request();

    if (!activityStatus.isGranted) {
      print('Activity recognition permission denied');
      return false;
    }

    // Request health data permissions
    try {
      // Check current permissions status
      final hasPermissions = await _health.hasPermissions(_healthDataTypes);

      if (hasPermissions != true) {
        // Request authorization - this should trigger the OS permission dialog
        final granted = await _health.requestAuthorization(
          _healthDataTypes,
          permissions: [
            HealthDataAccess.READ_WRITE,
            HealthDataAccess.READ_WRITE,
            HealthDataAccess.READ_WRITE,
          ],
        );
        print('Health permissions granted: $granted');
        return granted;
      }

      return true;
    } catch (e) {
      print('Error requesting health permissions: $e');
      return false;
    }
  }

  // Check if we have permissions
  Future<bool> hasPermissions() async {
    try {
      await _ensureConfigured();
      
      final activityStatus = await Permission.activityRecognition.status;
      if (!activityStatus.isGranted) {
        return false;
      }

      final hasPermissions = await _health.hasPermissions(_healthDataTypes);
      return hasPermissions == true;
    } catch (e) {
      print('Error checking health permissions: $e');
      return false;
    }
  }

  // Fetch step count for a given date
  Future<int> getStepsForDate(DateTime date) async {
    try {
      await _ensureConfigured();
      
      final midnight = DateTime(date.year, date.month, date.day);
      final endOfDay = midnight.add(const Duration(days: 1));

      final healthData = await _health.getHealthDataFromTypes(
        types: [HealthDataType.STEPS],
        startTime: midnight,
        endTime: endOfDay,
      );

      // Sum up all step data points
      int totalSteps = 0;
      for (var data in healthData) {
        if (data.type == HealthDataType.STEPS) {
          totalSteps += (data.value as num).toInt();
        }
      }

      return totalSteps;
    } catch (e) {
      print('Error fetching steps: $e');
      return 0;
    }
  }

  // Fetch active calories burned for a given date
  Future<double> getCaloriesBurnedForDate(DateTime date) async {
    try {
      await _ensureConfigured();
      
      final midnight = DateTime(date.year, date.month, date.day);
      final endOfDay = midnight.add(const Duration(days: 1));

      final healthData = await _health.getHealthDataFromTypes(
        types: [HealthDataType.ACTIVE_ENERGY_BURNED],
        startTime: midnight,
        endTime: endOfDay,
      );

      // Sum up all calorie data points
      double totalCalories = 0;
      for (var data in healthData) {
        if (data.type == HealthDataType.ACTIVE_ENERGY_BURNED) {
          totalCalories += (data.value as num).toDouble();
        }
      }

      return totalCalories;
    } catch (e) {
      print('Error fetching calories burned: $e');
      return 0;
    }
  }

  // Calculate estimated calories from steps using BMR and activity factor
  // Average person burns about 0.04-0.06 calories per step
  double calculateCaloriesFromSteps(int steps, double bmr) {
    // Use 0.05 calories per step as an average
    const caloriesPerStep = 0.05;
    final activeCalories = steps * caloriesPerStep;

    // Add BMR for the day
    final totalCalories = bmr + activeCalories;

    return totalCalories;
  }

  // Fetch health data for a date range
  Future<Map<DateTime, HealthData>> getHealthDataForRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final Map<DateTime, HealthData> healthDataMap = {};

    try {
      DateTime currentDate = startDate;

      while (currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
        final steps = await getStepsForDate(currentDate);
        final calories = await getCaloriesBurnedForDate(currentDate);

        healthDataMap[currentDate] = HealthData(
          date: currentDate,
          steps: steps,
          caloriesBurned: calories,
        );

        currentDate = currentDate.add(const Duration(days: 1));
      }
    } catch (e) {
      print('Error fetching health data for range: $e');
    }

    return healthDataMap;
  }
}

// Simple data class to hold health data for a specific date
class HealthData {
  final DateTime date;
  final int steps;
  final double caloriesBurned;

  HealthData({
    required this.date,
    required this.steps,
    required this.caloriesBurned,
  });
}
