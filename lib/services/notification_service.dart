import '../models/notification.dart';
import '../repositories/notification_repository.dart';

class NotificationService {
  final NotificationRepository _notificationRepo;

  NotificationService(this._notificationRepo);

  Future<List<AppNotification>> getNotifications() => _notificationRepo.getNotifications();

  Future<void> markAsRead(String id) => _notificationRepo.markAsRead(id);

  Future<void> markAllAsRead() => _notificationRepo.markAllAsRead();
}
