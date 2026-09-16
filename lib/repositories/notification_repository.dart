import '../models/notification.dart';

abstract class NotificationRepository {
  Future<List<AppNotification>> getNotifications();
}
