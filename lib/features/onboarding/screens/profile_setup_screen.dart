import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/strings.dart';
import '../../../data/models/user_profile.dart';
import '../../../shared/providers/user_provider.dart';
import '../../../shared/widgets/simple_number_field.dart';
import '../../dashboard/screens/dashboard_screen.dart';
import '../../health/screens/health_permissions_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  final String selectedGoal;

  const ProfileSetupScreen({super.key, required this.selectedGoal});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  int _age = 0;
  int _heightCm = 0;
  int _currentWeight = 0;
  int _goalWeight = 0;
  bool _isMale = true;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submitProfile() async {
    if (_formKey.currentState!.validate() &&
        _age > 0 &&
        _heightCm > 0 &&
        _currentWeight > 0 &&
        _goalWeight > 0) {
      // Create user profile
      final profile = UserProfile(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        currentWeight: _currentWeight.toDouble(),
        goalWeight: _goalWeight.toDouble(),
        heightCm: _heightCm.toDouble(),
        age: _age,
        isMale: _isMale,
        goal: widget.selectedGoal,
        dailyCalorieTarget: 2000, // This will be calculated based on goal
        createdAt: DateTime.now(),
      );

      // Save to provider (which saves to SharedPreferences)
      await Provider.of<UserProvider>(
        context,
        listen: false,
      ).saveUserProfile(profile);

      if (!mounted) return;

      // Navigate to health permissions screen
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => HealthPermissionsScreen(
            onPermissionsGranted: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => DashboardScreen(userProfile: profile),
                ),
                (route) => false,
              );
            },
          ),
        ),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title
                  Text(
                        'Tell us about yourself',
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
                    'We\'ll use this to personalize your experience',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.white.withOpacity(0.9),
                    ),
                  ).animate().fadeIn(delay: 100.ms, duration: 600.ms),

                  const SizedBox(height: 32),

                  // Name
                  _buildTextField(
                    controller: _nameController,
                    label: 'Name',
                    hint: 'Enter your name',
                    icon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ).animate().fadeIn(delay: 200.ms, duration: 600.ms),

                  const SizedBox(height: 16),

                  // Gender Selection
                  _buildGenderSelector().animate().fadeIn(
                    delay: 300.ms,
                    duration: 600.ms,
                  ),

                  const SizedBox(height: 16),

                  // Age Picker
                  SimpleNumberField(
                    label: 'Age',
                    hint: 'Select your age',
                    icon: Icons.cake_outlined,
                    minValue: 13,
                    maxValue: 100,
                    currentValue: _age,
                    unit: 'years',
                    onChanged: (value) => setState(() => _age = value),
                  ).animate().fadeIn(delay: 400.ms, duration: 600.ms),

                  const SizedBox(height: 16),

                  // Height Picker
                  SimpleNumberField(
                    label: 'Height',
                    hint: 'Select your height',
                    icon: Icons.height,
                    minValue: 120,
                    maxValue: 220,
                    currentValue: _heightCm,
                    unit: 'cm',
                    onChanged: (value) => setState(() => _heightCm = value),
                  ).animate().fadeIn(delay: 500.ms, duration: 600.ms),

                  const SizedBox(height: 16),

                  // Current Weight Picker
                  SimpleNumberField(
                    label: 'Current Weight',
                    hint: 'Select your current weight',
                    icon: Icons.monitor_weight_outlined,
                    minValue: 30,
                    maxValue: 200,
                    currentValue: _currentWeight,
                    unit: 'kg',
                    onChanged: (value) =>
                        setState(() => _currentWeight = value),
                  ).animate().fadeIn(delay: 600.ms, duration: 600.ms),

                  const SizedBox(height: 16),

                  // Goal Weight Picker
                  SimpleNumberField(
                    label: 'Goal Weight',
                    hint: 'Select your goal weight',
                    icon: Icons.flag_outlined,
                    minValue: 30,
                    maxValue: 200,
                    currentValue: _goalWeight,
                    unit: 'kg',
                    onChanged: (value) => setState(() => _goalWeight = value),
                  ).animate().fadeIn(delay: 700.ms, duration: 600.ms),

                  const SizedBox(height: 32),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _submitProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.skyBlue,
                        elevation: 4,
                        shadowColor: Colors.black.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        AppStrings.finish,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 800.ms, duration: 600.ms),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: const TextStyle(
          color: AppColors.black,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: AppColors.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey[500],
            fontSize: 16,
          ),
          prefixIcon: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(right: 12),
            child: Icon(
              icon,
              color: AppColors.skyBlue,
              size: 24,
            ),
          ),
          filled: false,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.skyBlue, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _GenderOption(
                label: 'Male',
                icon: Icons.male,
                isSelected: _isMale,
                onTap: () => setState(() => _isMale = true),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _GenderOption(
                label: 'Female',
                icon: Icons.female,
                isSelected: !_isMale,
                onTap: () => setState(() => _isMale = false),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _GenderOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.skyBlue : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.skyBlue : Colors.grey[600],
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.skyBlue : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
