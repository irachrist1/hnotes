import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/strings.dart';
import '../../../data/models/meal_entry.dart';
import '../../../shared/providers/daily_log_provider.dart';
import '../services/perplexity_service.dart';

class MealInputScreen extends StatefulWidget {
  const MealInputScreen({super.key});

  @override
  State<MealInputScreen> createState() => _MealInputScreenState();
}

class _MealInputScreenState extends State<MealInputScreen> {
  final _controller = TextEditingController();
  final _perplexityService = PerplexityService();
  bool _isAnalyzing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _analyzeMeal() async {
    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please describe your meal')),
      );
      return;
    }

    setState(() => _isAnalyzing = true);

    try {
      // Analyze meal using Perplexity AI
      final analysis = await _perplexityService.analyzeMeal(
        _controller.text.trim(),
      );

      // Create meal entry
      final meal = MealEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        description: analysis.foodName,
        calories: analysis.calories,
        timestamp: DateTime.now(),
        aiAnalysis: analysis.breakdown,
      );

      // Save to provider
      if (mounted) {
        await Provider.of<DailyLogProvider>(
          context,
          listen: false,
        ).addMeal(meal);
      }

      setState(() => _isAnalyzing = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Logged: ${analysis.foodName} (${analysis.calories} cal)',
            ),
            backgroundColor: const Color(0xFF4CAF50),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() => _isAnalyzing = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error analyzing meal: $e'),
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
          AppStrings.logMeal,
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
                      'What did you eat?',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Describe your meal in natural language',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 32),

                    // Input field
                    TextField(
                      controller: _controller,
                      maxLines: 4,
                      enabled: !_isAnalyzing,
                      decoration: InputDecoration(
                        hintText: AppStrings.mealInputHint,
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.skyBlue,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      autofocus: true,
                    ),

                    const SizedBox(height: 24),

                    // Examples
                    if (!_isAnalyzing) ...[
                      Text(
                        'Examples:',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildExampleChip('Grilled chicken salad with olive oil'),
                      const SizedBox(height: 8),
                      _buildExampleChip('Oatmeal with banana and honey'),
                      const SizedBox(height: 8),
                      _buildExampleChip(
                        'Turkey sandwich with lettuce and tomato',
                      ),
                    ],

                    // Extra space for button area
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),

            // Fixed Submit button at bottom
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
                      gradient: _isAnalyzing ? null : AppColors.blueGradient,
                      color: _isAnalyzing ? Colors.grey[300] : null,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton(
                      onPressed: _isAnalyzing ? null : _analyzeMeal,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.transparent,
                        disabledForegroundColor: Colors.grey[600],
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isAnalyzing
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
                              'Analyze Meal',
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

  Widget _buildExampleChip(String text) {
    return GestureDetector(
      onTap: () {
        _controller.text = text;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.skyBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.skyBlue.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.restaurant, size: 16, color: AppColors.skyBlue),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
