import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/colors.dart';
import '../services/health_service.dart';

class HealthPermissionsScreen extends StatefulWidget {
  final VoidCallback onPermissionsGranted;

  const HealthPermissionsScreen({
    super.key,
    required this.onPermissionsGranted,
  });

  @override
  State<HealthPermissionsScreen> createState() => _HealthPermissionsScreenState();
}

class _HealthPermissionsScreenState extends State<HealthPermissionsScreen> {
  bool _isLoading = false;

  Future<void> _requestPermissions() async {
    setState(() => _isLoading = true);

    final healthService = HealthService();
    final granted = await healthService.requestPermissions();

    setState(() => _isLoading = false);

    if (granted) {
      widget.onPermissionsGranted();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Health permissions are required for step tracking'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.blueGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 
                            MediaQuery.of(context).padding.top - 
                            MediaQuery.of(context).padding.bottom - 48,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),

                    // Icon
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.health_and_safety,
                        size: 100,
                        color: AppColors.white,
                      ),
                    ).animate().fadeIn(duration: 600.ms).scale(
                          delay: 100.ms,
                          duration: 600.ms,
                        ),

                    const SizedBox(height: 40),

                    // Title
                    Text(
                      'Health Permissions',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(delay: 200.ms, duration: 600.ms),

                    const SizedBox(height: 16),

                    // Description
                    Text(
                      'HNotes needs access to your health data to track your steps and calculate calories burned',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.white.withOpacity(0.9),
                          ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(delay: 300.ms, duration: 600.ms),

                    const SizedBox(height: 48),

                    // Permission items
                    _PermissionItem(
                      icon: Icons.directions_walk,
                      title: 'Step Count',
                      description: 'Track your daily steps automatically',
                    ).animate().fadeIn(delay: 400.ms, duration: 600.ms).slideX(
                          begin: -0.2,
                          end: 0,
                        ),

                    const SizedBox(height: 16),

                    _PermissionItem(
                      icon: Icons.local_fire_department,
                      title: 'Calories Burned',
                      description: 'Calculate energy expenditure from activity',
                    ).animate().fadeIn(delay: 500.ms, duration: 600.ms).slideX(
                          begin: -0.2,
                          end: 0,
                        ),

                    const SizedBox(height: 16),

                    _PermissionItem(
                      icon: Icons.timeline,
                      title: 'Activity History',
                      description: 'View your progress over time',
                    ).animate().fadeIn(delay: 600.ms, duration: 600.ms).slideX(
                          begin: -0.2,
                          end: 0,
                        ),

                    const Spacer(),

                    // Grant Permission Button
                    ElevatedButton(
                      onPressed: _isLoading ? null : _requestPermissions,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.white,
                        foregroundColor: AppColors.skyBlue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.skyBlue,
                              ),
                            )
                          : const Text('Grant Permissions'),
                    ).animate().fadeIn(delay: 700.ms, duration: 600.ms),

                    const SizedBox(height: 12),

                    // Skip Button
                    TextButton(
                      onPressed: widget.onPermissionsGranted,
                      child: Text(
                        'Skip for now',
                        style: TextStyle(
                          color: AppColors.white.withOpacity(0.8),
                        ),
                      ),
                    ).animate().fadeIn(delay: 800.ms, duration: 600.ms),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PermissionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _PermissionItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
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
      ),
    );
  }
}
