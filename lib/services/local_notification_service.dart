import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final LocalNotificationService _notificationService =
      LocalNotificationService._internal();

  final _localNotificaationsPlugin = FlutterLocalNotificationsPlugin();

  factory LocalNotificationService() {
    return _notificationService;
  }

  LocalNotificationService._internal();

  Future<void> setupNotification() async {
    const androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
    // const iosSetting = IOS
    const initSettings = InitializationSettings(android: androidSetting);

    await _localNotificaationsPlugin
        .initialize(initSettings)
        .then((value) => debugPrint('setupPlugin: setup success'))
        .catchError((Object error) {
      debugPrint('Error: $error');
    });
  }

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
