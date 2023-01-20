class LocalNotificationService {
  static final LocalNotificationService _notificationService =
      LocalNotificationService._internal();

  factory LocalNotificationService() {
    return _notificationService;
  }

  LocalNotificationService._internal();

  Future<void> addNotification(
    String title,
    String body,
    int endTime, {
    String sound = '',
    String channel = 'default',
  }) async {
    print('addNotification() called: title=$title body=$body');
  }
}
