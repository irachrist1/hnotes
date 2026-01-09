import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/colors.dart';
import '../../../shared/providers/daily_log_provider.dart';
import '../../../data/models/meal_entry.dart';

class MealHistoryScreen extends StatelessWidget {
  const MealHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dailyLogProvider = Provider.of<DailyLogProvider>(context);

    // Get last 7 days of logs
    final endDate = DateTime.now();
    final startDate = endDate.subtract(const Duration(days: 6));
    final logs = dailyLogProvider.getLogsForRange(startDate, endDate);

    // Group meals by date
    final Map<String, List<MealEntry>> mealsByDate = {};
    for (var log in logs) {
      if (log.meals.isNotEmpty) {
        final dateKey = DateFormat('yyyy-MM-dd').format(log.date);
        mealsByDate[dateKey] = log.meals;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Meal History',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.blueGradient,
          ),
        ),
      ),
      body: mealsByDate.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: mealsByDate.length,
              itemBuilder: (context, index) {
                final dateKey = mealsByDate.keys.elementAt(index);
                final meals = mealsByDate[dateKey]!;
                final date = DateTime.parse(dateKey);

                return _buildDateSection(context, date, meals);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              'No meals logged yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Start logging your meals to see your history here',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSection(
    BuildContext context,
    DateTime date,
    List<MealEntry> meals,
  ) {
    final isToday =
        DateFormat('yyyy-MM-dd').format(date) ==
        DateFormat('yyyy-MM-dd').format(DateTime.now());
    final dateLabel = isToday
        ? 'Today'
        : DateFormat('EEEE, MMM d').format(date);

    final totalCalories = meals.fold<int>(
      0,
      (sum, meal) => sum + meal.calories,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date header
        Padding(
          padding: const EdgeInsets.only(left: 4, top: 8, bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateLabel,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: AppColors.blueGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$totalCalories cal',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Meal cards
        ...meals.map((meal) => _buildMealCard(context, meal)),

        const SizedBox(height: 16),
        const Divider(),
      ],
    );
  }

  Widget _buildMealCard(BuildContext context, MealEntry meal) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF4ECDC4).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.restaurant,
                color: Color(0xFF4ECDC4),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),

            // Meal info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.description,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('h:mm a').format(meal.timestamp),
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  if (meal.aiAnalysis != null &&
                      meal.aiAnalysis!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      meal.aiAnalysis!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // Calories
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${meal.calories}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.skyBlue,
                  ),
                ),
                const Text(
                  'cal',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
