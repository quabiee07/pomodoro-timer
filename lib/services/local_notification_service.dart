import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;

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
    tzData.initializeTimeZones();
    final scheduleTime =
        tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, endTime);

    final androidDetail = AndroidNotificationDetails(channel, channel);

    // final iosDetail = IOSNotification();
    final noticeDetail = NotificationDetails(android: androidDetail);

    final id = 0;

    await _localNotificaationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduleTime,
      noticeDetail,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true
    );
    
    print('addNotification() called: title=$title body=$body');
  }
}
