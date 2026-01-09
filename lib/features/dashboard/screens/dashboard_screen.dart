import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/strings.dart';
import '../../../data/models/user_profile.dart';
import '../../../shared/providers/daily_log_provider.dart';
import '../widgets/today_action_card.dart';
import '../widgets/calorie_balance_card.dart';
import '../widgets/stat_card.dart';
import '../widgets/progress_card.dart';
import '../../intake_tracking/screens/meal_input_screen.dart';
import '../../intake_tracking/screens/meal_history_screen.dart';
import '../../burn_tracking/screens/activity_input_screen.dart';
import '../../settings/screens/settings_screen.dart';
import '../../notifications/screens/notifications_screen.dart';

class DashboardScreen extends StatefulWidget {
  final UserProfile userProfile;

  const DashboardScreen({super.key, required this.userProfile});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Sync health data when dashboard loads
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<DailyLogProvider>(
        context,
        listen: false,
      ).syncHealthData(bmr: widget.userProfile.bmr);
    });
  }

  void _showMealInput() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const MealInputScreen()));
  }

  void _showActivityInput() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ActivityInputScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dailyLogProvider = Provider.of<DailyLogProvider>(context);
    final todayLog = dailyLogProvider.todayLog;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.skyBlue.withOpacity(0.1), AppColors.white],
            stops: const [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                floating: true,
                expandedHeight: 80,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, ${widget.userProfile.name}',
                        style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: AppColors.black,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const NotificationsScreen(),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.settings_outlined,
                      color: AppColors.black,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              // Content
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Today's Action Card (Most prominent)
                    TodayActionCard(
                          userProfile: widget.userProfile,
                          todayLog: todayLog,
                        )
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .slideY(begin: 0.1, end: 0, duration: 600.ms),

                    const SizedBox(height: 24),

                    // Calorie Balance Card
                    CalorieBalanceCard(
                          todayLog: todayLog,
                          targetCalories: widget.userProfile.dailyCalorieTarget,
                        )
                        .animate()
                        .fadeIn(delay: 100.ms, duration: 600.ms)
                        .slideY(begin: 0.1, end: 0, duration: 600.ms),

                    const SizedBox(height: 16),

                    // Quick Stats Row
                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            title: AppStrings.burned,
                            value: todayLog.caloriesBurned.toString(),
                            unit: 'cal',
                            icon: Icons.local_fire_department,
                            color: const Color(0xFFFF6B6B),
                          ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: StatCard(
                            title: AppStrings.consumed,
                            value: todayLog.caloriesConsumed.toString(),
                            unit: 'cal',
                            icon: Icons.restaurant,
                            color: const Color(0xFF4ECDC4),
                          ).animate().fadeIn(delay: 300.ms, duration: 600.ms),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            title: AppStrings.steps,
                            value: todayLog.steps.toString(),
                            unit: 'steps',
                            icon: Icons.directions_walk,
                            color: const Color(0xFF95E1D3),
                          ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: StatCard(
                            title: 'Balance',
                            value: todayLog.calorieBalance.abs().toString(),
                            unit: todayLog.calorieBalance >= 0
                                ? 'deficit'
                                : 'surplus',
                            icon: Icons.balance,
                            color: todayLog.calorieBalance >= 0
                                ? const Color(0xFF4CAF50)
                                : const Color(0xFFFF9800),
                          ).animate().fadeIn(delay: 500.ms, duration: 600.ms),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Progress Card
                    ProgressCard(
                          userProfile: widget.userProfile,
                          todayLog: todayLog,
                        )
                        .animate()
                        .fadeIn(delay: 600.ms, duration: 600.ms)
                        .slideY(begin: 0.1, end: 0, duration: 600.ms),

                    const SizedBox(height: 24),

                    // Quick Actions
                    _buildQuickActions().animate().fadeIn(
                      delay: 700.ms,
                      duration: 600.ms,
                    ),

                    // Extra padding for FAB - prevents overlap
                    const SizedBox(height: 100),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showMealInput,
        backgroundColor: AppColors.skyBlue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(AppStrings.logMeal),
      ).animate().scale(delay: 800.ms, duration: 600.ms),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickActionButton(
                icon: Icons.restaurant_menu,
                label: 'Log Meal',
                color: const Color(0xFF4ECDC4),
                onTap: _showMealInput,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionButton(
                icon: Icons.fitness_center,
                label: 'Log Activity',
                color: const Color(0xFFFF6B6B),
                onTap: _showActivityInput,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickActionButton(
                icon: Icons.history,
                label: 'Meal History',
                color: const Color(0xFF9C27B0),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const MealHistoryScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionButton(
                icon: Icons.analytics_outlined,
                label: 'View Progress',
                color: const Color(0xFFFF9800),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Analytics coming soon!')),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
