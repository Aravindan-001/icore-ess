import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/injection_providers.dart';
import '../../models/notification.dart';

final notificationsProvider = AsyncNotifierProvider<NotificationsNotifier, List<AppNotification>>(() {
  return NotificationsNotifier();
});

class NotificationsNotifier extends AsyncNotifier<List<AppNotification>> {
  @override
  Future<List<AppNotification>> build() async {
    final service = ref.watch(notificationServiceProvider);
    return service.getNotifications();
  }

  Future<void> markAsRead(String id) async {
    final service = ref.read(notificationServiceProvider);
    await service.markAsRead(id);
    ref.invalidateSelf();
    await future;
  }

  Future<void> markAllAsRead() async {
    final service = ref.read(notificationServiceProvider);
    await service.markAllAsRead();
    ref.invalidateSelf();
    await future;
  }
}

enum NotificationViewFilter { 
  all, 
  unread, 
  leave, 
  attendance, 
  payroll, 
  request, 
  system,
  general
}

final notificationFilterProvider = StateProvider<NotificationViewFilter>((ref) => NotificationViewFilter.all);

final filteredNotificationsProvider = Provider<AsyncValue<List<AppNotification>>>((ref) {
  final notificationsAsync = ref.watch(notificationsProvider);
  final filter = ref.watch(notificationFilterProvider);

  return notificationsAsync.when(
    data: (list) {
      if (filter == NotificationViewFilter.all) return AsyncValue.data(list);
      if (filter == NotificationViewFilter.unread) {
        return AsyncValue.data(list.where((n) => !n.isRead).toList());
      }
      
      // Filter by category
      final filtered = list.where((n) => n.category.name == filter.name).toList();
      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: (err, stack) => AsyncValue.error(err, stack),
  );
});

final unreadNotificationCountProvider = Provider<int>((ref) {
  final notificationsAsync = ref.watch(notificationsProvider);
  return notificationsAsync.maybeWhen(
    data: (list) => list.where((n) => !n.isRead).length,
    orElse: () => 0,
  );
});
