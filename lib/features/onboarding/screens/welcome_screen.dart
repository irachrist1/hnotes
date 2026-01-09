import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/strings.dart';
import 'goal_selection_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.blueGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),

                // App Logo/Icon (placeholder - can be replaced with actual logo)
                Icon(
                  Icons.favorite_rounded,
                  size: 80,
                  color: AppColors.white,
                ).animate().scale(duration: 600.ms, curve: Curves.easeOut),

                const SizedBox(height: 24),

                // App Name
                Text(
                  AppStrings.appName,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: AppColors.white,
                        fontSize: 48,
                      ),
                ).animate().fadeIn(duration: 800.ms).slideY(
                      begin: 0.3,
                      end: 0,
                      duration: 800.ms,
                      curve: Curves.easeOut,
                    ),

                const SizedBox(height: 16),

                // Tagline
                Text(
                  AppStrings.appTagline,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.white.withOpacity(0.9),
                        fontSize: 18,
                      ),
                ).animate().fadeIn(delay: 200.ms, duration: 800.ms).slideY(
                      begin: 0.3,
                      end: 0,
                      duration: 800.ms,
                      curve: Curves.easeOut,
                    ),

                const SizedBox(height: 48),

                // Feature highlights
                _FeatureItem(
                  icon: Icons.track_changes,
                  title: 'Smart Tracking',
                  description: 'Automatic calorie and activity tracking',
                ).animate().fadeIn(delay: 400.ms, duration: 600.ms),

                const SizedBox(height: 16),

                _FeatureItem(
                  icon: Icons.lightbulb_outline,
                  title: 'AI Guidance',
                  description: 'Personalized daily action recommendations',
                ).animate().fadeIn(delay: 600.ms, duration: 600.ms),

                const SizedBox(height: 16),

                _FeatureItem(
                  icon: Icons.rocket_launch,
                  title: 'Simple & Fast',
                  description: 'One glance, one action, zero friction',
                ).animate().fadeIn(delay: 800.ms, duration: 600.ms),

                const Spacer(),

                // Get Started Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const GoalSelectionScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.skyBlue,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    AppStrings.getStarted,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ).animate().fadeIn(delay: 1000.ms, duration: 600.ms).slideY(
                      begin: 0.2,
                      end: 0,
                      duration: 600.ms,
                      curve: Curves.easeOut,
                    ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppColors.white,
            size: 28,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: AppColors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
