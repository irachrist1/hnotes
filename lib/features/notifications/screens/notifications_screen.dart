import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/colors.dart';
import '../../../data/models/app_notification.dart';
import '../../../shared/providers/notification_provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // Load notifications when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NotificationProvider>(
        context,
        listen: false,
      ).loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, notificationProvider, child) {
        final notifications = notificationProvider.notifications;

        // Group notifications by date
        final Map<String, List<AppNotification>> groupedNotifications = {};
        for (var notification in notifications) {
          final dateKey = _getDateLabel(notification.timestamp);
          groupedNotifications.putIfAbsent(dateKey, () => []);
          groupedNotifications[dateKey]!.add(notification);
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Notifications',
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
            actions: [
              if (notificationProvider.hasUnread)
                TextButton(
                  onPressed: () => notificationProvider.markAllAsRead(),
                  child: const Text(
                    'Mark all read',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              if (notifications.isNotEmpty)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onSelected: (value) {
                    if (value == 'clear') {
                      _showClearConfirmation(context, notificationProvider);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'clear',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Clear all'),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
          body: !notificationProvider.isLoaded
              ? const Center(child: CircularProgressIndicator())
              : notifications.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  itemCount: groupedNotifications.length,
                  itemBuilder: (context, index) {
                    final dateKey = groupedNotifications.keys.elementAt(index);
                    final dateNotifications = groupedNotifications[dateKey]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader(dateKey),
                        ...dateNotifications.map(
                          (notification) => _buildNotificationTile(
                            context,
                            notification,
                            notificationProvider,
                          ),
                        ),
                        if (index < groupedNotifications.length - 1)
                          const Divider(height: 1),
                      ],
                    );
                  },
                ),
        );
      },
    );
  }

  void _showClearConfirmation(
    BuildContext context,
    NotificationProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Notifications'),
        content: const Text(
          'Are you sure you want to clear all notifications?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.clearAll();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  String _getDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final notificationDate = DateTime(date.year, date.month, date.day);

    if (notificationDate == today) {
      return 'Today';
    } else if (notificationDate == yesterday) {
      return 'Yesterday';
    } else if (notificationDate.isAfter(
      today.subtract(const Duration(days: 7)),
    )) {
      return 'This Week';
    } else {
      return 'Earlier';
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              'No notifications yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Start logging meals and activities to receive personalized updates and achievements',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
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

  Widget _buildNotificationTile(
    BuildContext context,
    AppNotification notification,
    NotificationProvider provider,
  ) {
    final iconData = _getIconForType(notification.type);
    final iconColor = _getColorForType(notification.type);

    return Dismissible(
      key: Key(notification.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        provider.deleteNotification(notification.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notification deleted'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        color: notification.isRead
            ? Colors.transparent
            : AppColors.skyBlue.withOpacity(0.05),
        child: ListTile(
          onTap: () => provider.markAsRead(notification.id),
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(iconData, color: iconColor, size: 24),
          ),
          title: Text(
            notification.title,
            style: TextStyle(
              fontWeight: notification.isRead
                  ? FontWeight.normal
                  : FontWeight.w600,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(notification.message),
              const SizedBox(height: 4),
              Text(
                _formatTime(notification.timestamp),
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),
          trailing: !notification.isRead
              ? Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.skyBlue,
                    shape: BoxShape.circle,
                  ),
                )
              : null,
          isThreeLine: true,
        ),
      ),
    );
  }

  IconData _getIconForType(NotificationType type) {
    switch (type) {
      case NotificationType.welcome:
        return Icons.celebration;
      case NotificationType.tip:
        return Icons.tips_and_updates;
      case NotificationType.goalAchieved:
        return Icons.check_circle_outline;
      case NotificationType.progressUpdate:
        return Icons.trending_up;
      case NotificationType.streak:
        return Icons.local_fire_department;
      case NotificationType.milestone:
        return Icons.emoji_events;
      case NotificationType.reminder:
        return Icons.alarm;
      case NotificationType.mealLogged:
        return Icons.restaurant;
      case NotificationType.activityLogged:
        return Icons.fitness_center;
      case NotificationType.general:
        return Icons.notifications;
    }
  }

  Color _getColorForType(NotificationType type) {
    switch (type) {
      case NotificationType.welcome:
        return const Color(0xFFFFC107);
      case NotificationType.tip:
        return AppColors.skyBlue;
      case NotificationType.goalAchieved:
        return const Color(0xFF4CAF50);
      case NotificationType.progressUpdate:
        return const Color(0xFFFF9800);
      case NotificationType.streak:
        return const Color(0xFFFF6B6B);
      case NotificationType.milestone:
        return const Color(0xFFFFC107);
      case NotificationType.reminder:
        return const Color(0xFF9C27B0);
      case NotificationType.mealLogged:
        return const Color(0xFF4ECDC4);
      case NotificationType.activityLogged:
        return const Color(0xFFFF6B6B);
      case NotificationType.general:
        return Colors.grey;
    }
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return DateFormat('MMM d, h:mm a').format(timestamp);
    }
  }
}
