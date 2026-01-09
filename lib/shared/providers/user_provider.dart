import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/user_profile.dart';

class UserProvider with ChangeNotifier {
  UserProfile? _userProfile;
  bool _isLoading = false;

  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  bool get hasCompletedOnboarding => _userProfile != null;

  // Load user profile from local storage
  Future<void> loadUserProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString('user_profile');

      if (userDataString != null) {
        final userData = jsonDecode(userDataString) as Map<String, dynamic>;
        _userProfile = UserProfile.fromJson(userData);
      }
    } catch (e) {
      debugPrint('Error loading user profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save user profile
  Future<void> saveUserProfile(UserProfile profile) async {
    try {
      _userProfile = profile;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userDataString = jsonEncode(profile.toJson());
      await prefs.setString('user_profile', userDataString);
    } catch (e) {
      debugPrint('Error saving user profile: $e');
    }
  }

  // Update current weight
  Future<void> updateCurrentWeight(double newWeight) async {
    if (_userProfile == null) return;

    final updatedProfile = _userProfile!.copyWith(currentWeight: newWeight);
    await saveUserProfile(updatedProfile);
  }

  // Update goal weight
  Future<void> updateGoalWeight(double newGoalWeight) async {
    if (_userProfile == null) return;

    final updatedProfile = _userProfile!.copyWith(goalWeight: newGoalWeight);
    await saveUserProfile(updatedProfile);
  }

  // Update user name
  Future<void> updateName(String newName) async {
    if (_userProfile == null) return;

    final updatedProfile = _userProfile!.copyWith(name: newName);
    await saveUserProfile(updatedProfile);
  }

  // Update goal
  Future<void> updateGoal(String newGoal) async {
    if (_userProfile == null) return;

    final updatedProfile = _userProfile!.copyWith(goal: newGoal);
    await saveUserProfile(updatedProfile);
  }

  // Clear user data (for logout/reset)
  Future<void> clearUserData() async {
    _userProfile = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_profile');
  }
}
