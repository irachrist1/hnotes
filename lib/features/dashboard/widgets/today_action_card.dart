import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/models/daily_log.dart';
import '../../../features/guidance/services/guidance_service.dart';

class TodayActionCard extends StatelessWidget {
  final UserProfile userProfile;
  final DailyLog todayLog;

  const TodayActionCard({
    super.key,
    required this.userProfile,
    required this.todayLog,
  });

  String _generateDailyAction() {
    final guidanceService = GuidanceService();
    return guidanceService.getDailyRecommendation(
      userProfile: userProfile,
      todayLog: todayLog,
    );
  }

  IconData _getActionIcon() {
    final currentDeficit = todayLog.caloriesBurned - todayLog.caloriesConsumed;
    final targetDeficit = userProfile.targetDeficit;

    if (currentDeficit >= targetDeficit - 50) {
      return Icons.check_circle_outline;
    } else {
      return Icons.lightbulb_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.blueGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.skyBlue.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getActionIcon(),
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'What To Do Today',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _generateDailyAction(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
