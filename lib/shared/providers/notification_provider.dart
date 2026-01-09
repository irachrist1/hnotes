import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/app_notification.dart';

/// Provider for managing real in-app notifications
class NotificationProvider with ChangeNotifier {
  List<AppNotification> _notifications = [];
  bool _hasUnread = false;
  bool _isLoaded = false;

  List<AppNotification> get notifications => _notifications;
  bool get hasUnread => _hasUnread;
  int get unreadCount => _notifications.where((n) => !n.isRead).length;
  bool get isLoaded => _isLoaded;

  /// Load notifications from local storage
  Future<void> loadNotifications() async {
    if (_isLoaded) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final notifString = prefs.getString('app_notifications');
      
      if (notifString != null) {
        final notifList = jsonDecode(notifString) as List;
        _notifications = notifList
            .map((n) => AppNotification.fromJson(n as Map<String, dynamic>))
            .toList();
        // Sort by timestamp, newest first
        _notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      }
      
      _updateUnreadStatus();
      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading notifications: $e');
      _isLoaded = true;
      notifyListeners();
    }
  }

  Future<void> _saveNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notifString = jsonEncode(_notifications.map((n) => n.toJson()).toList());
      await prefs.setString('app_notifications', notifString);
    } catch (e) {
      debugPrint('Error saving notifications: $e');
    }
  }

  void _updateUnreadStatus() {
    _hasUnread = _notifications.any((n) => !n.isRead);
  }

  /// Add a new notification
  Future<void> addNotification(AppNotification notification) async {
    _notifications.insert(0, notification);
    _updateUnreadStatus();
    notifyListeners();
    await _saveNotifications();
  }

  /// Mark a specific notification as read
  Future<void> markAsRead(String notificationId) async {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      _updateUnreadStatus();
      notifyListeners();
      await _saveNotifications();
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
    _updateUnreadStatus();
    notifyListeners();
    await _saveNotifications();
  }

  /// Delete a specific notification
  Future<void> deleteNotification(String notificationId) async {
    _notifications.removeWhere((n) => n.id == notificationId);
    _updateUnreadStatus();
    notifyListeners();
    await _saveNotifications();
  }

  /// Clear all notifications
  Future<void> clearAll() async {
    _notifications = [];
    _hasUnread = false;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('app_notifications');
  }

  // ============ Notification Generators ============

  /// Generate welcome notification for new users
  Future<void> generateWelcomeNotification() async {
    await addNotification(AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Welcome to HNotes! 🎉',
      message: 'Start tracking your health journey today. Log your first meal to get started!',
      type: NotificationType.welcome,
      timestamp: DateTime.now(),
    ));
  }

  /// Generate notification when meal is logged
  Future<void> generateMealLoggedNotification(String mealName, int calories) async {
    await addNotification(AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Meal Logged',
      message: 'You logged $mealName ($calories cal). Keep tracking!',
      type: NotificationType.mealLogged,
      timestamp: DateTime.now(),
    ));
  }

  /// Generate notification when activity is logged
  Future<void> generateActivityLoggedNotification(String activityName, int calories) async {
    await addNotification(AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Activity Logged 💪',
      message: 'Great job! You burned $calories cal with $activityName.',
      type: NotificationType.activityLogged,
      timestamp: DateTime.now(),
    ));
  }

  /// Generate notification when daily goal is achieved
  Future<void> generateGoalAchievedNotification() async {
    await addNotification(AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Goal Achieved! 🎯',
      message: 'Congratulations! You reached your daily calorie deficit goal.',
      type: NotificationType.goalAchieved,
      timestamp: DateTime.now(),
    ));
  }

  /// Generate streak notification
  Future<void> generateStreakNotification(int days) async {
    await addNotification(AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '$days-Day Streak! 🔥',
      message: 'You\'ve been consistent for $days days in a row. Amazing work!',
      type: NotificationType.streak,
      timestamp: DateTime.now(),
    ));
  }

  /// Generate milestone notification
  Future<void> generateMilestoneNotification(String milestone) async {
    await addNotification(AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Milestone Reached! 🏆',
      message: milestone,
      type: NotificationType.milestone,
      timestamp: DateTime.now(),
    ));
  }

  /// Generate daily tip notification
  Future<void> generateDailyTip(String tip) async {
    await addNotification(AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Daily Tip 💡',
      message: tip,
      type: NotificationType.tip,
      timestamp: DateTime.now(),
    ));
  }

  /// Generate progress update notification
  Future<void> generateProgressUpdate(String message) async {
    await addNotification(AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Progress Update 📊',
      message: message,
      type: NotificationType.progressUpdate,
      timestamp: DateTime.now(),
    ));
  }
}
