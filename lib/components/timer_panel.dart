import 'package:flutter/material.dart';

import '../app_styles.dart';

class TimerPanel extends StatelessWidget {
  final int remainTime; // seconds
  final Color bgColor;
  const TimerPanel({
    Key? key,
    this.remainTime = 0,
    this.bgColor = colorLightRed,
  }) : super(key: key);

  String formatText(int timeValue) {
    final minutes = timeValue.toDouble() ~/ 60;
    final seconds = timeValue.toInt() % 60;

    final minStr = minutes.toString().padLeft(2, '0');
    final secStr = seconds.toString().padLeft(2, '0');

    return '$minStr:$secStr';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 120,
      color: bgColor,
      child: Center(
          child: Text(
        formatText(remainTime),
        style: timerTextStyle,
      )),
    );
  }
}