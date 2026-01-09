import 'package:flutter/material.dart';
import '../../../data/models/daily_log.dart';

class CalorieBalanceCard extends StatelessWidget {
  final DailyLog todayLog;
  final int targetCalories;

  const CalorieBalanceCard({
    super.key,
    required this.todayLog,
    required this.targetCalories,
  });

  @override
  Widget build(BuildContext context) {
    final balance = todayLog.calorieBalance;
    final isDeficit = balance >= 0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Calorie Balance',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Icon(
                  isDeficit ? Icons.trending_down : Icons.trending_up,
                  color: isDeficit ? const Color(0xFF4CAF50) : const Color(0xFFFF9800),
                  size: 28,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  balance.abs().toString(),
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: isDeficit ? const Color(0xFF4CAF50) : const Color(0xFFFF9800),
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    'cal ${isDeficit ? 'deficit' : 'surplus'}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildProgressBar(balance, targetCalories),
            const SizedBox(height: 16),
            Text(
              isDeficit
                  ? 'You\'re burning more than you\'re consuming 🔥'
                  : 'You\'re consuming more than you\'re burning',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(int balance, int target) {
    final percentage = (balance / target).clamp(0.0, 1.0);
    final isDeficit = balance >= 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Target: $target cal deficit',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            Text(
              '${(percentage * 100).round()}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 12,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              isDeficit ? const Color(0xFF4CAF50) : const Color(0xFFFF9800),
            ),
          ),
        ),
      ],
    );
  }
}
