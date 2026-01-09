import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../data/models/activity_entry.dart';
import '../../../shared/providers/daily_log_provider.dart';

class ActivityInputScreen extends StatefulWidget {
  const ActivityInputScreen({super.key});

  @override
  State<ActivityInputScreen> createState() => _ActivityInputScreenState();
}

class _ActivityInputScreenState extends State<ActivityInputScreen> {
  String? _selectedActivity;
  int _durationMinutes = 30;
  bool _isSaving = false;

  final List<ActivityOption> _activities = [
    ActivityOption(
      id: 'walking',
      name: 'Walking',
      icon: Icons.directions_walk,
      color: const Color(0xFF4CAF50),
      caloriesPerMinute: 4,
    ),
    ActivityOption(
      id: 'running',
      name: 'Running',
      icon: Icons.directions_run,
      color: const Color(0xFFFF5722),
      caloriesPerMinute: 10,
    ),
    ActivityOption(
      id: 'cycling',
      name: 'Cycling',
      icon: Icons.directions_bike,
      color: const Color(0xFF2196F3),
      caloriesPerMinute: 7,
    ),
    ActivityOption(
      id: 'gym',
      name: 'Gym Workout',
      icon: Icons.fitness_center,
      color: const Color(0xFF9C27B0),
      caloriesPerMinute: 8,
    ),
    ActivityOption(
      id: 'swimming',
      name: 'Swimming',
      icon: Icons.pool,
      color: const Color(0xFF00BCD4),
      caloriesPerMinute: 9,
    ),
    ActivityOption(
      id: 'yoga',
      name: 'Yoga',
      icon: Icons.self_improvement,
      color: const Color(0xFFE91E63),
      caloriesPerMinute: 3,
    ),
    ActivityOption(
      id: 'sports',
      name: 'Sports',
      icon: Icons.sports_basketball,
      color: const Color(0xFFFF9800),
      caloriesPerMinute: 8,
    ),
    ActivityOption(
      id: 'other',
      name: 'Other Activity',
      icon: Icons.more_horiz,
      color: const Color(0xFF607D8B),
      caloriesPerMinute: 5,
    ),
  ];

  int get _estimatedCalories {
    if (_selectedActivity == null) return 0;
    final activity = _activities.firstWhere((a) => a.id == _selectedActivity);
    return activity.caloriesPerMinute * _durationMinutes;
  }

  Future<void> _saveActivity() async {
    if (_selectedActivity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an activity')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final selectedActivityOption = _activities.firstWhere(
        (a) => a.id == _selectedActivity,
      );

      final activity = ActivityEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: selectedActivityOption.name,
        durationMinutes: _durationMinutes,
        caloriesBurned: _estimatedCalories,
        timestamp: DateTime.now(),
      );

      await Provider.of<DailyLogProvider>(
        context,
        listen: false,
      ).addActivity(activity);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Logged: ${selectedActivityOption.name} ($_estimatedCalories cal burned)',
            ),
            backgroundColor: const Color(0xFF4CAF50),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving activity: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Log Activity',
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
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'What did you do?',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ).animate().fadeIn(duration: 400.ms),
                    const SizedBox(height: 8),
                    Text(
                      'Select your activity type',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                    ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
                    const SizedBox(height: 24),

                    // Activity Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.5,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemCount: _activities.length,
                      itemBuilder: (context, index) {
                        final activity = _activities[index];
                        final isSelected = _selectedActivity == activity.id;
                        return _ActivityCard(
                          activity: activity,
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              _selectedActivity = activity.id;
                            });
                          },
                        ).animate().fadeIn(
                          delay: (150 + index * 50).ms,
                          duration: 400.ms,
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    // Duration Selector
                    Text(
                      'Duration',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate().fadeIn(delay: 500.ms, duration: 400.ms),
                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '$_durationMinutes min',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.skyBlue,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Slider(
                            value: _durationMinutes.toDouble(),
                            min: 5,
                            max: 180,
                            divisions: 35,
                            activeColor: AppColors.skyBlue,
                            onChanged: (value) {
                              setState(() {
                                _durationMinutes = value.round();
                              });
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '5 min',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                              Text(
                                '3 hours',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 600.ms, duration: 400.ms),

                    const SizedBox(height: 24),

                    // Estimated Calories
                    if (_selectedActivity != null)
                      Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6B6B).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFFF6B6B).withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFFFF6B6B,
                                    ).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.local_fire_department,
                                    color: Color(0xFFFF6B6B),
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Estimated Burn',
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      '$_estimatedCalories calories',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFFF6B6B),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                          .animate()
                          .fadeIn(duration: 300.ms)
                          .scale(
                            begin: const Offset(0.95, 0.95),
                            end: const Offset(1, 1),
                          ),

                    // Extra padding for button area
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),

            // Save Button - Fixed at bottom
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: (_isSaving || _selectedActivity == null) ? null : AppColors.blueGradient,
                      color: (_isSaving || _selectedActivity == null) ? Colors.grey[300] : null,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton(
                      onPressed: _isSaving || _selectedActivity == null
                          ? null
                          : _saveActivity,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.transparent,
                        disabledForegroundColor: Colors.grey[600],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'Log Activity',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActivityOption {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final int caloriesPerMinute;

  ActivityOption({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.caloriesPerMinute,
  });
}

class _ActivityCard extends StatelessWidget {
  final ActivityOption activity;
  final bool isSelected;
  final VoidCallback onTap;

  const _ActivityCard({
    required this.activity,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? activity.color.withOpacity(0.15) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? activity.color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: activity.color.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(activity.icon, color: activity.color, size: 32),
            const SizedBox(height: 8),
            Text(
              activity.name,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? activity.color : Colors.grey[700],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
