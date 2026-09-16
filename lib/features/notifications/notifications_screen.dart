import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/utils/dependency_injection.dart';
import '../../core/widgets/empty_state.dart';
import '../../models/notification.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: FutureBuilder<List<AppNotification>>(
        future: DependencyInjection.notificationService.getNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading notifications'));
          }

          final notifications = snapshot.data!;
          if (notifications.isEmpty) {
            return const EmptyState(
              title: 'No Notifications',
              message: 'You are all caught up!',
              icon: Icons.notifications_none_outlined,
            );
          }

          return ListView.separated(
            itemCount: notifications.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = notifications[index];
              final isRead = item.isRead;
              
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: !isRead ? colorScheme.primary.withValues(alpha: 0.1) : Colors.transparent,
                  child: Icon(
                    !isRead ? Icons.notifications_active : Icons.notifications_none,
                    color: !isRead ? colorScheme.primary : colorScheme.outline,
                  ),
                ),
                title: Text(
                  item.title, 
                  style: TextStyle(fontWeight: !isRead ? FontWeight.bold : FontWeight.normal)
                ),
                subtitle: Text(item.message),
                trailing: Text(
                  _formatTimestamp(item.timestamp), 
                  style: TextStyle(fontSize: 10, color: colorScheme.outline)
                ),
                onTap: () {},
              );
            },
          );
        },
      ),
    );
  }


  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return DateFormat('dd MMM').format(timestamp);
    }
  }
}
