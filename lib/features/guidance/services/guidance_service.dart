import '../../../data/models/user_profile.dart';
import '../../../data/models/daily_log.dart';

class GuidanceService {
  /// Generate daily action recommendation based on user's current progress
  String getDailyRecommendation({
    required UserProfile userProfile,
    required DailyLog todayLog,
  }) {
    final calorieBalance = todayLog.calorieBalance;
    final consumed = todayLog.caloriesConsumed;
    final burned = todayLog.caloriesBurned;
    final steps = todayLog.steps;
    final targetCalories = userProfile.dailyCalorieTarget;
    final goal = userProfile.goal;

    // Different recommendations based on goal
    switch (goal) {
      case 'lose_weight':
        return _getLoseWeightRecommendation(
          calorieBalance: calorieBalance,
          consumed: consumed,
          burned: burned,
          steps: steps,
          targetCalories: targetCalories,
        );
      case 'build_muscle':
        return _getBuildMuscleRecommendation(
          calorieBalance: calorieBalance,
          consumed: consumed,
          burned: burned,
          steps: steps,
          targetCalories: targetCalories,
        );
      case 'maintain':
        return _getMaintainRecommendation(
          calorieBalance: calorieBalance,
          consumed: consumed,
          burned: burned,
          steps: steps,
          targetCalories: targetCalories,
        );
      case 'improve_energy':
        return _getImproveEnergyRecommendation(
          calorieBalance: calorieBalance,
          consumed: consumed,
          burned: burned,
          steps: steps,
          targetCalories: targetCalories,
        );
      default:
        return 'Keep tracking your meals and activity!';
    }
  }

  String _getLoseWeightRecommendation({
    required int calorieBalance,
    required int consumed,
    required int burned,
    required int steps,
    required int targetCalories,
  }) {
    // For weight loss, we want a calorie deficit
    if (consumed == 0 && steps == 0) {
      return 'Start your day! Log your breakfast and take a walk to get those steps in.';
    }

    if (calorieBalance > 500) {
      // Great deficit
      return 'Excellent work! You\'re on track with your weight loss goal. Keep it up!';
    } else if (calorieBalance > 200) {
      // Good deficit
      return 'Good progress today! Consider a 15-minute walk to boost your calorie burn.';
    } else if (calorieBalance >= 0) {
      // Small deficit
      return 'You\'re close to your target. Try to add more activity or reduce portion sizes.';
    } else if (calorieBalance > -300) {
      // Small surplus
      return 'Slight surplus today. Consider a light workout or skip that evening snack.';
    } else {
      // Large surplus
      return 'High calorie intake today. Focus on lighter meals and increase your activity.';
    }
  }

  String _getBuildMuscleRecommendation({
    required int calorieBalance,
    required int consumed,
    required int burned,
    required int steps,
    required int targetCalories,
  }) {
    // For muscle building, we want a slight surplus
    if (consumed == 0 && steps == 0) {
      return 'Fuel your muscles! Have a protein-rich breakfast and get moving.';
    }

    if (calorieBalance < -300) {
      // Good surplus
      return 'Great job fueling your body! Make sure to include protein with each meal.';
    } else if (calorieBalance < 0) {
      // Small surplus
      return 'Good intake! Consider adding a protein shake or snack to support muscle growth.';
    } else if (calorieBalance < 300) {
      // Small deficit
      return 'You\'re in a slight deficit. Add a protein-rich snack to support your muscle goals.';
    } else {
      // Large deficit
      return 'You need more calories to build muscle. Add nutrient-dense meals and snacks.';
    }
  }

  String _getMaintainRecommendation({
    required int calorieBalance,
    required int consumed,
    required int burned,
    required int steps,
    required int targetCalories,
  }) {
    // For maintenance, we want balance
    if (consumed == 0 && steps == 0) {
      return 'Good morning! Start with a balanced breakfast and some light activity.';
    }

    if (calorieBalance.abs() < 200) {
      // Perfect balance
      return 'Perfect balance! You\'re maintaining your weight well. Keep it consistent.';
    } else if (calorieBalance > 200) {
      // Deficit
      return 'You\'re in a deficit. Add a healthy snack to maintain your current weight.';
    } else {
      // Surplus
      return 'Slight surplus today. Consider a walk or reduce portion sizes at dinner.';
    }
  }

  String _getImproveEnergyRecommendation({
    required int calorieBalance,
    required int consumed,
    required int burned,
    required int steps,
    required int targetCalories,
  }) {
    if (consumed == 0 && steps == 0) {
      return 'Boost your energy! Start with a nutritious breakfast and get moving.';
    }

    if (steps < 2000) {
      return 'Take a brisk walk! Movement boosts energy levels and improves mood.';
    } else if (steps < 5000) {
      return 'Good start! Aim for 7,000+ steps today to maximize your energy levels.';
    } else if (steps < 8000) {
      return 'Great activity! Stay hydrated and eat balanced meals for sustained energy.';
    } else {
      return 'Excellent activity level! Your energy should be great. Keep it up!';
    }
  }

  /// Get motivational message based on progress
  String getMotivationalMessage({
    required UserProfile userProfile,
    required List<DailyLog> recentLogs,
  }) {
    if (recentLogs.isEmpty) {
      return 'Welcome to HNotes! Start tracking to see your progress.';
    }

    // Calculate streak (consecutive days with logged data)
    int streak = 0;
    for (var log in recentLogs.reversed) {
      if (log.meals.isNotEmpty || log.steps > 0) {
        streak++;
      } else {
        break;
      }
    }

    if (streak >= 7) {
      return '🔥 $streak day streak! You\'re crushing it!';
    } else if (streak >= 3) {
      return '💪 $streak days in a row! Keep the momentum going!';
    } else if (streak >= 1) {
      return '⭐ Great start! Build your streak by logging daily.';
    } else {
      return '👋 Ready for a fresh start? Log your first meal today!';
    }
  }

  /// Get specific actionable tip
  String getActionableTip({
    required UserProfile userProfile,
    required DailyLog todayLog,
  }) {
    final steps = todayLog.steps;
    final consumed = todayLog.caloriesConsumed;
    final mealsLogged = todayLog.meals.length;

    // Tips based on current state
    if (mealsLogged == 0) {
      return '📱 Tip: Log your meals as you eat for better accuracy!';
    }

    if (steps < 1000) {
      return '🚶 Tip: Even a short 10-minute walk can boost your mood and burn!';
    }

    if (consumed > 0 && consumed < 800) {
      return '🥗 Tip: Make sure you\'re eating enough to fuel your body!';
    }

    if (mealsLogged < 3) {
      return '⏰ Tip: Aim to log all your meals for complete tracking!';
    }

    // Default tips
    final tips = [
      '💧 Tip: Drink water before meals to help with portion control!',
      '🥦 Tip: Fill half your plate with vegetables for nutrients and fullness!',
      '😴 Tip: Good sleep is crucial for weight management!',
      '📊 Tip: Review your meal history to spot patterns!',
      '🎯 Tip: Set small, achievable goals each week!',
    ];

    return tips[DateTime.now().day % tips.length];
  }
}
