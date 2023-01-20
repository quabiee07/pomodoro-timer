import 'package:flutter/material.dart';
import 'package:pomodoro_timer/pomodoro_app.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PomodoroApp());
}
