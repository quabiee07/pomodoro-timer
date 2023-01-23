import 'package:flutter/material.dart';
import 'package:pomodoro_timer/pomodoro_app.dart';
import 'package:pomodoro_timer/services/local_notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotificationService().setupNotification();
  runApp(const PomodoroApp());
}
