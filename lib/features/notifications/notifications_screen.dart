import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/empty_state.dart';
import '../../models/notification.dart';
import '../../core/providers/injection_providers.dart';
import 'notifications_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(filteredNotificationsProvider);
    final currentFilter = ref.watch(notificationFilterProvider);

    return Scaffold(
      backgroundColor: AppTheme.surfaceContainer,
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all, color: AppTheme.primaryBlue),
            tooltip: 'Mark all as read',
            onPressed: () => ref.read(notificationsProvider.notifier).markAllAsRead(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterBar(ref, currentFilter),
          Expanded(
            child: notificationsAsync.when(
              data: (list) => _buildNotificationList(context, ref, list),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => _buildErrorState(ref, err),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(WidgetRef ref, NotificationViewFilter currentFilter) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppTheme.outline, width: 0.5)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: NotificationViewFilter.values.map((filter) {
            final isSelected = currentFilter == filter;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(_capitalize(filter.name)),
                selected: isSelected,
                onSelected: (_) => ref.read(notificationFilterProvider.notifier).state = filter,
                backgroundColor: Colors.white,
                selectedColor: AppTheme.primaryBlue.withValues(alpha: 0.1),
                checkmarkColor: AppTheme.primaryBlue,
                labelStyle: TextStyle(
                  color: isSelected ? AppTheme.primaryBlue : AppTheme.textMuted,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected ? AppTheme.primaryBlue : AppTheme.outline,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildNotificationList(BuildContext context, WidgetRef ref, List<AppNotification> list) {
    if (list.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => ref.refresh(notificationsProvider.future),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: const EmptyState(
              title: 'No Notifications',
              message: 'You are all caught up!',
              icon: Icons.notifications_none_outlined,
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.refresh(notificationsProvider.future),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: list.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = list[index];
          final categoryColor = _getCategoryColor(item.category);
          final categoryIcon = _getCategoryIcon(item.category);

          return Card(
            margin: EdgeInsets.zero,
            elevation: item.isRead ? 0 : 2,
            color: item.isRead ? Colors.white : const Color(0xFFF0F7FF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: item.isRead ? AppTheme.outline.withValues(alpha: 0.5) : AppTheme.primaryBlue.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: InkWell(
              onTap: () {
                ref.read(analyticsServiceProvider).logEvent('notification_opened');
                if (!item.isRead) {
                  ref.read(notificationsProvider.notifier).markAsRead(item.id);
                }
                if (item.route != null) {
                  Navigator.pushNamed(context, item.route!);
                }
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: item.isRead ? AppTheme.surfaceContainer : categoryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        categoryIcon,
                        color: item.isRead ? AppTheme.textMuted : categoryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: !item.isRead ? FontWeight.bold : FontWeight.w600,
                                    color: AppTheme.textMain,
                                  ),
                                ),
                              ),
                              if (!item.isRead)
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: AppTheme.primaryBlue,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.message,
                            style: TextStyle(
                              fontSize: 13, 
                              color: item.isRead ? AppTheme.textMuted : AppTheme.textMain.withValues(alpha: 0.8),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppTheme.surfaceContainer,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  _capitalize(item.category.name),
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.textMuted),
                                ),
                              ),
                              Text(
                                _formatTimestamp(item.timestamp),
                                style: const TextStyle(fontSize: 11, color: AppTheme.textMuted),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getCategoryColor(NotificationCategory category) {
    switch (category) {
      case NotificationCategory.leave: return Colors.orange;
      case NotificationCategory.attendance: return Colors.green;
      case NotificationCategory.payroll: return Colors.blue;
      case NotificationCategory.request: return Colors.purple;
      case NotificationCategory.system: return Colors.red;
      case NotificationCategory.general: return AppTheme.primaryBlue;
    }
  }

  IconData _getCategoryIcon(NotificationCategory category) {
    switch (category) {
      case NotificationCategory.leave: return Icons.event_note;
      case NotificationCategory.attendance: return Icons.location_on;
      case NotificationCategory.payroll: return Icons.payments;
      case NotificationCategory.request: return Icons.assignment;
      case NotificationCategory.system: return Icons.settings_suggest;
      case NotificationCategory.general: return Icons.notifications;
    }
  }

  Widget _buildErrorState(WidgetRef ref, Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppTheme.error),
          const SizedBox(height: 16),
          const Text('Failed to load notifications'),
          TextButton(
            onPressed: () => ref.refresh(notificationsProvider),
            child: const Text('Retry'),
          ),
        ],
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
      return DateFormat('dd MMM yyyy').format(timestamp);
    }
  }

  String _capitalize(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}
