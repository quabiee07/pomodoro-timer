import 'package:flutter/material.dart';
import 'package:pomodoro_timer/components/timer.dart';


class PomodoroApp extends StatelessWidget {
  const PomodoroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.light(),
      home: PomodoroTimer(),
    );
  }
}