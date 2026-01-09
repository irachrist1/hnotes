import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/strings.dart';
import 'profile_setup_screen.dart';

class GoalSelectionScreen extends StatefulWidget {
  const GoalSelectionScreen({super.key});

  @override
  State<GoalSelectionScreen> createState() => _GoalSelectionScreenState();
}

class _GoalSelectionScreenState extends State<GoalSelectionScreen> {
  String? _selectedGoal;

  final List<GoalOption> _goals = [
    GoalOption(
      id: 'lose_weight',
      title: AppStrings.goalLoseWeight,
      description: 'Shed pounds and feel lighter',
      icon: Icons.trending_down,
      color: const Color(0xFF4CAF50),
    ),
    GoalOption(
      id: 'build_muscle',
      title: AppStrings.goalBuildMuscle,
      description: 'Get stronger and more toned',
      icon: Icons.fitness_center,
      color: const Color(0xFFFF9800),
    ),
    GoalOption(
      id: 'maintain',
      title: AppStrings.goalMaintain,
      description: 'Keep your current weight',
      icon: Icons.favorite,
      color: const Color(0xFFE91E63),
    ),
    GoalOption(
      id: 'improve_energy',
      title: AppStrings.goalImproveEnergy,
      description: 'Boost your daily energy levels',
      icon: Icons.bolt,
      color: const Color(0xFFFFC107),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.blueGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title
                Text(
                      'What\'s your goal?',
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                    )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: -0.2, end: 0, duration: 600.ms),

                const SizedBox(height: 8),

                Text(
                  'Choose one that fits you best',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.white.withOpacity(0.9),
                  ),
                ).animate().fadeIn(delay: 100.ms, duration: 600.ms),

                const SizedBox(height: 32),

                // Goal options
                Expanded(
                  child: ListView.builder(
                    itemCount: _goals.length,
                    itemBuilder: (context, index) {
                      final goal = _goals[index];
                      final isSelected = _selectedGoal == goal.id;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child:
                            _GoalCard(
                              goal: goal,
                              isSelected: isSelected,
                              onTap: () {
                                setState(() {
                                  _selectedGoal = goal.id;
                                });
                              },
                            ).animate().fadeIn(
                              delay: (200 + index * 100).ms,
                              duration: 600.ms,
                            ),
                      );
                    },
                  ),
                ),

                // Continue Button
                ElevatedButton(
                  onPressed: _selectedGoal == null
                      ? null
                      : () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProfileSetupScreen(
                                selectedGoal: _selectedGoal!,
                              ),
                            ),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.skyBlue,
                    disabledBackgroundColor: AppColors.white.withOpacity(0.5),
                  ),
                  child: const Text(AppStrings.next),
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GoalOption {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  GoalOption({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class _GoalCard extends StatelessWidget {
  final GoalOption goal;
  final bool isSelected;
  final VoidCallback onTap;

  const _GoalCard({
    required this.goal,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          // FIXED: Always use solid white background for better contrast
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.skyBlue : Colors.grey[300]!,
            width: isSelected ? 3 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.skyBlue.withOpacity(0.3)
                  : Colors.black.withOpacity(0.05),
              blurRadius: isSelected ? 12 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: goal.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(goal.icon, color: goal.color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      // FIXED: Use goal color when selected for visual feedback
                      color: isSelected ? goal.color : AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    goal.description,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            // Checkmark indicator - always visible space, shown when selected
            AnimatedOpacity(
              opacity: isSelected ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.skyBlue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
