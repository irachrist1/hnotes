import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../shared/providers/user_provider.dart';
import '../../../shared/providers/daily_log_provider.dart';
import '../../onboarding/screens/welcome_screen.dart';
import '../../health/screens/health_permissions_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.userProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
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
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                // User Profile Section
                Container(
                  color: AppColors.skyBlue.withOpacity(0.1),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.skyBlue,
                        child: Text(
                          user.name.isNotEmpty
                              ? user.name[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getGoalText(user.goal),
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Profile Settings
                _buildSectionHeader('Profile'),
                _buildSettingsTile(
                  icon: Icons.person_outline,
                  title: 'Edit Profile',
                  subtitle: 'Update your personal information',
                  onTap: () {
                    _showEditProfileDialog(context, userProvider);
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.monitor_weight_outlined,
                  title: 'Current Weight',
                  subtitle: '${user.currentWeight.toStringAsFixed(1)} kg',
                  trailing: const Icon(Icons.edit, size: 20),
                  onTap: () {
                    _showUpdateWeightDialog(context, userProvider);
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.flag_outlined,
                  title: 'Goal Weight',
                  subtitle: '${user.goalWeight.toStringAsFixed(1)} kg',
                  trailing: const Icon(Icons.edit, size: 20),
                  onTap: () {
                    _showUpdateGoalWeightDialog(context, userProvider);
                  },
                ),

                const Divider(),

                // App Settings
                _buildSectionHeader('App Settings'),
                _buildSettingsTile(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  subtitle: 'Manage notification preferences',
                  onTap: () {
                    _showNotificationSettings(context);
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.health_and_safety_outlined,
                  title: 'Health Permissions',
                  subtitle: 'Manage health data access',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => HealthPermissionsScreen(
                          onPermissionsGranted: () {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Health permissions updated!'),
                                backgroundColor: Color(0xFF4CAF50),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
                _buildSettingsTile(
                  icon: Icons.palette_outlined,
                  title: 'Theme',
                  subtitle: 'Light mode',
                  onTap: () {
                    _showThemeSettings(context);
                  },
                ),

                const Divider(),

                // About
                _buildSectionHeader('About'),
                _buildSettingsTile(
                  icon: Icons.info_outline,
                  title: 'App Version',
                  subtitle: '1.0.0',
                  onTap: () {},
                ),
                _buildSettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  subtitle: 'Read our privacy policy',
                  onTap: () {
                    _showPrivacyPolicy(context);
                  },
                ),

                const Divider(),

                // Danger Zone
                _buildSectionHeader('Account'),
                _buildSettingsTile(
                  icon: Icons.logout,
                  title: 'Logout',
                  subtitle: 'Clear all data and start over',
                  titleColor: Colors.red,
                  onTap: () => _showLogoutDialog(context),
                ),

                const SizedBox(height: 32),
              ],
            ),
    );
  }

  String _getGoalText(String goal) {
    switch (goal) {
      case 'lose_weight':
        return 'Goal: Lose Weight';
      case 'build_muscle':
        return 'Goal: Build Muscle';
      case 'maintain':
        return 'Goal: Stay Healthy';
      case 'improve_energy':
        return 'Goal: Improve Energy';
      default:
        return 'Goal: ${goal.replaceAll('_', ' ')}';
    }
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
    Color? titleColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: titleColor ?? AppColors.skyBlue),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w500, color: titleColor),
      ),
      subtitle: Text(subtitle),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showUpdateWeightDialog(
    BuildContext context,
    UserProvider userProvider,
  ) {
    final controller = TextEditingController(
      text: userProvider.userProfile!.currentWeight.toStringAsFixed(1),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Current Weight'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Weight (kg)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newWeight = double.tryParse(controller.text);
              if (newWeight != null && newWeight > 0) {
                await userProvider.updateCurrentWeight(newWeight);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Weight updated successfully!'),
                    ),
                  );
                }
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showUpdateGoalWeightDialog(
    BuildContext context,
    UserProvider userProvider,
  ) {
    final controller = TextEditingController(
      text: userProvider.userProfile!.goalWeight.toStringAsFixed(1),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Goal Weight'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Goal Weight (kg)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newWeight = double.tryParse(controller.text);
              if (newWeight != null && newWeight > 0) {
                await userProvider.updateGoalWeight(newWeight);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Goal weight updated successfully!'),
                    ),
                  );
                }
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(
    BuildContext context,
    UserProvider userProvider,
  ) {
    final nameController = TextEditingController(
      text: userProvider.userProfile!.name,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newName = nameController.text.trim();
              if (newName.isNotEmpty) {
                await userProvider.updateName(newName);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile updated successfully!'),
                    ),
                  );
                }
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text(
          'Are you sure you want to logout? This will clear all your data.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Clear all data
              await Provider.of<UserProvider>(
                context,
                listen: false,
              ).clearUserData();
              await Provider.of<DailyLogProvider>(
                context,
                listen: false,
              ).clearAllLogs();

              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notification Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _NotificationToggle(
              title: 'Daily Reminders',
              subtitle: 'Remind me to log meals',
              value: true,
              onChanged: (value) {},
            ),
            _NotificationToggle(
              title: 'Goal Achievements',
              subtitle: 'Notify when I reach my goals',
              value: true,
              onChanged: (value) {},
            ),
            _NotificationToggle(
              title: 'Weekly Progress',
              subtitle: 'Weekly summary reports',
              value: true,
              onChanged: (value) {},
            ),
            _NotificationToggle(
              title: 'Tips & Motivation',
              subtitle: 'Health tips and encouragement',
              value: false,
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Notification preferences saved!'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.skyBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Save'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showThemeSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Theme Settings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _ThemeOption(
              title: 'Light',
              icon: Icons.light_mode,
              isSelected: true,
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Light theme selected')),
                );
              },
            ),
            _ThemeOption(
              title: 'Dark',
              icon: Icons.dark_mode,
              isSelected: false,
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Dark theme coming soon!')),
                );
              },
            ),
            _ThemeOption(
              title: 'System',
              icon: Icons.settings_suggest,
              isSelected: false,
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('System theme coming soon!')),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Privacy Policy',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPrivacySection(
                        'Data Collection',
                        'HNotes collects health and fitness data that you provide, including meals logged, activities, and body measurements. This data is stored locally on your device.',
                      ),
                      _buildPrivacySection(
                        'Health Connect Integration',
                        'With your permission, HNotes accesses step count and activity data from Android Health Connect. This data is used solely to calculate calories burned and track your progress.',
                      ),
                      _buildPrivacySection(
                        'Data Storage',
                        'All your personal data is stored locally on your device. We do not upload your health data to any external servers.',
                      ),
                      _buildPrivacySection(
                        'AI Features',
                        'When you use the meal analysis feature, your meal descriptions are processed to estimate calorie content. No personal identifying information is included in these requests.',
                      ),
                      _buildPrivacySection(
                        'Your Rights',
                        'You can delete all your data at any time by using the Logout option in Settings. This will permanently remove all stored information.',
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Last updated: January 2026',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacySection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationToggle extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotificationToggle({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  State<_NotificationToggle> createState() => _NotificationToggleState();
}

class _NotificationToggleState extends State<_NotificationToggle> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  widget.subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Switch(
            value: _value,
            onChanged: (value) {
              setState(() => _value = value);
              widget.onChanged(value);
            },
            activeColor: AppColors.skyBlue,
          ),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? AppColors.skyBlue : Colors.grey),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: isSelected ? AppColors.skyBlue : null,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check, color: AppColors.skyBlue)
          : null,
      onTap: onTap,
    );
  }
}
