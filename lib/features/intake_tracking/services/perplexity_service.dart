import 'dart:convert';
import 'package:http/http.dart' as http;

class PerplexityService {
  // Note: In production, store API key securely (environment variables, secure storage, etc.)
  static const String _apiKey = 'YOUR_PERPLEXITY_API_KEY_HERE';
  static const String _baseUrl = 'https://api.perplexity.ai/chat/completions';

  Future<MealAnalysisResult> analyzeMeal(String mealDescription) async {
    try {
      // Check if API key is configured
      if (_apiKey == 'YOUR_PERPLEXITY_API_KEY_HERE') {
        // Fallback to simple estimation if API key not configured
        return _estimateMealCalories(mealDescription);
      }

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'llama-3.1-sonar-small-128k-online',
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are a nutritionist assistant. Analyze the food description and provide the total estimated calories. '
                  'Respond in JSON format with: {"food": "description", "calories": number, "breakdown": "brief explanation"}. '
                  'Be concise and accurate.',
            },
            {
              'role': 'user',
              'content':
                  'Analyze this meal and estimate calories: $mealDescription',
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'] as String;

        // Parse JSON response from AI
        final analysisData = jsonDecode(content);

        return MealAnalysisResult(
          foodName: analysisData['food'] as String,
          calories: (analysisData['calories'] as num).toInt(),
          breakdown: analysisData['breakdown'] as String,
        );
      } else {
        throw Exception('Failed to analyze meal: ${response.statusCode}');
      }
    } catch (e) {
      print('Error analyzing meal: $e');
      // Fallback to simple estimation
      return _estimateMealCalories(mealDescription);
    }
  }

  // Simple fallback estimation when API is not available
  MealAnalysisResult _estimateMealCalories(String mealDescription) {
    final lowerDescription = mealDescription.toLowerCase();
    
    // Simple keyword-based estimation
    int estimatedCalories = 400; // Default for average meal
    String foodName = mealDescription;
    String breakdown = 'Estimated based on meal description';

    // Meal type detection
    if (lowerDescription.contains('breakfast')) {
      estimatedCalories = 350;
      breakdown = 'Typical breakfast meal';
    } else if (lowerDescription.contains('lunch')) {
      estimatedCalories = 500;
      breakdown = 'Typical lunch meal';
    } else if (lowerDescription.contains('dinner')) {
      estimatedCalories = 600;
      breakdown = 'Typical dinner meal';
    } else if (lowerDescription.contains('snack')) {
      estimatedCalories = 150;
      breakdown = 'Light snack';
    }

    // Food type adjustments
    if (lowerDescription.contains('salad')) {
      estimatedCalories = 250;
      breakdown = 'Light salad meal';
    } else if (lowerDescription.contains('pizza')) {
      estimatedCalories = 700;
      breakdown = 'Pizza meal (2-3 slices)';
    } else if (lowerDescription.contains('burger')) {
      estimatedCalories = 650;
      breakdown = 'Burger meal with sides';
    } else if (lowerDescription.contains('sandwich') || lowerDescription.contains('wrap')) {
      estimatedCalories = 400;
      breakdown = 'Sandwich or wrap';
    } else if (lowerDescription.contains('pasta')) {
      estimatedCalories = 550;
      breakdown = 'Pasta dish';
    } else if (lowerDescription.contains('rice')) {
      estimatedCalories = 450;
      breakdown = 'Rice-based meal';
    } else if (lowerDescription.contains('chicken')) {
      estimatedCalories = 400;
      breakdown = 'Chicken dish';
    } else if (lowerDescription.contains('fish')) {
      estimatedCalories = 350;
      breakdown = 'Fish dish';
    } else if (lowerDescription.contains('soup')) {
      estimatedCalories = 200;
      breakdown = 'Soup';
    } else if (lowerDescription.contains('fruit')) {
      estimatedCalories = 100;
      breakdown = 'Fresh fruit';
    } else if (lowerDescription.contains('vegetable')) {
      estimatedCalories = 100;
      breakdown = 'Vegetables';
    }

    return MealAnalysisResult(
      foodName: foodName,
      calories: estimatedCalories,
      breakdown: '$breakdown (Note: Add your Perplexity API key for AI-powered analysis)',
    );
  }
}

class MealAnalysisResult {
  final String foodName;
  final int calories;
  final String breakdown;

  MealAnalysisResult({
    required this.foodName,
    required this.calories,
    required this.breakdown,
  });

  Map<String, dynamic> toJson() => {
    'foodName': foodName,
    'calories': calories,
    'breakdown': breakdown,
  };

  factory MealAnalysisResult.fromJson(Map<String, dynamic> json) =>
      MealAnalysisResult(
        foodName: json['foodName'] as String,
        calories: json['calories'] as int,
        breakdown: json['breakdown'] as String,
      );
}
