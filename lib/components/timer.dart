import 'dart:async';

import 'package:flutter/material.dart';
import '../app_styles.dart';
import 'timer_panel.dart';

const int kWorkDuration = 1500; // production: 25 minutes
const int kRestDuration = 300; // production: 300 (5 minutes)
const int kLongRestDuration = 900; // production: 900 (15 minutes)
const int kLongRestInterval = 4; // 4 short rest and then 1 long rest

enum PomodoroState {
  none,
  beingWork,
  atWork,
  beginRest,
  atRest,
}

class PomodoroTimer extends StatefulWidget {
  final _state = _PomodoroTimerState();
  PomodoroTimer({Key? key}) : super(key: key);

  void setRemainTime(int seconds, {Color color = Colors.white}) =>
      _state.setRemainTime(seconds, color: color);

  void changeState(PomodoroState state) {
    if (state == PomodoroState.beingWork) {
      _state.enterBeginWork();
    } else if (state == PomodoroState.beginRest) {
      _state.enterBeginRest();
    } else if (state == PomodoroState.atWork) {
      _state.enterAtWork();
    } else if (state == PomodoroState.atRest) {
      _state.enterAtRest();
    }
  }

  @override
  // ignore: no_logic_in_create_state
  State<PomodoroTimer> createState() => _state;
}

class _PomodoroTimerState extends State<PomodoroTimer> {
  PomodoroState _state = PomodoroState.none;
  int remainTime = 0; // Second
  int pomodoroCount = 0;
  Color timerBgColor = colorLightRed;
  Color mainColor = colorRed;

  String subTitle = '';
  String buttonCaption = 'buttonCaption';

  Timer? _timer;
  int _endTime = -1;
  

  @override
  void initState() {
    super.initState();
    enterBeginWork();
  }

  // ======= Widget Logic =======
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: mainColor,
      child: Column(
        children: [
          const Spacer(),
          _buildTitle(),
          const Spacer(),
          _buildSubTitle(),
          const SizedBox(height: 15),
          TimerPanel(
            remainTime: remainTime,
            bgColor: timerBgColor,
          ),
          const SizedBox(height: 5),
          _buildTimerButton(),
          const Spacer(flex: 6),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return const Text('Pomodoro Timer', style: timerTitleTextStyle);
  }

  Widget _buildSubTitle() {
    return Text(subTitle, style: timerSubTitleTextStyle);
  }

  Widget _buildTimerButton() {
    return TextButton(
      onPressed: () => onButtonClicked(),
      child: Container(
        width: 300,
        height: 50,
        color: colorLightGray,
        child: Center(
            child: Text(buttonCaption,
                style: TextStyle(
                  fontFamily: mainFont,
                  fontSize: 20.0,
                  color: mainColor,
                ))),
      ),
    );
  }

  // ======= Button  Logic =============
  void onButtonClicked() {
    debugPrint('onButtonClicked is called');
    if (_state == PomodoroState.beingWork) {
      enterAtWork();
    } else if (_state == PomodoroState.atWork) {
      // Discard
      // Next state: beingWork
      // #1
      _endAtWork(false);
    } else if (_state == PomodoroState.beginRest) {
      enterAtRest();
    } else if (_state == PomodoroState.atRest) {
      // Discard
      // Next state: beingWork
      _endAtRest();
    }
  }

  // ======= Utility =============
  bool shouldHaveLongBreak() {
    return pomodoroCount > 0 && pomodoroCount % kLongRestInterval == 0;
  }

  // ======== State  Logic =============
  void enterBeginWork() {
    _state = PomodoroState.beingWork;
    setState(() {
      remainTime = kWorkDuration;
      timerBgColor = colorLightRed;
      mainColor = colorRed;
      subTitle = 'Start to work';
      buttonCaption = 'START WORK';
    });
  }

  void enterBeginRest() {
    _state = PomodoroState.beginRest;
    final longBreak = shouldHaveLongBreak();
    setState(() {
      remainTime = longBreak ? kLongRestDuration : kRestDuration;
      timerBgColor = colorLightGreen;
      mainColor = colorGreen;
      subTitle = longBreak ? 'Let\'s take a long break' : 'Let\'s take a break';
      buttonCaption = 'START REST';
    });
  }

  void enterAtWork() {
    _state = PomodoroState.atWork;
    setState(() {
      remainTime = kWorkDuration;
      timerBgColor = colorLightRed;
      mainColor = colorRed;
      subTitle = 'Work in progress';
      buttonCaption = 'DISCARD';
    });

    // Define the endtime
    _endTime = DateTime.now().millisecondsSinceEpoch + remainTime * 1000;
    _startTimer();
  }

  void enterAtRest() {
    _state = PomodoroState.atRest;
    final longBreak = shouldHaveLongBreak();
    setState(() {
      remainTime = longBreak ? kLongRestDuration : kRestDuration;
      timerBgColor = colorLightGreen;
      mainColor = colorGreen;
      subTitle = 'Taking break';
      buttonCaption = 'DISCARD';
    });

    _endTime = DateTime.now().millisecondsSinceEpoch + remainTime * 1000;
    _startTimer();
  }

  // ======= Timer Logic =======
  void _startTimer() {
    if (remainTime == 0) {
      return;
    }

    // if (_timer != null) {
    //   _timer?._state
    // }

    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      final remainTime = _calculateRemainTime();
      setRemainTime(remainTime);
      if (remainTime <= 0) {
        _stopTimer();
      }
    });
    
  }

  void _stopTimer() {
    if (_state == PomodoroState.atWork) {
      _endAtWork(true);
    } else if (_state == PomodoroState.atRest) {
      _endAtRest();
    }
  }

  void _endAtRest() {
    _timer?.cancel();
    //
    enterBeginWork();
  }

  void _endAtWork(bool isCompleted) {
    if (isCompleted) {
      pomodoroCount++;
    }
    _timer?.cancel();
    enterBeginRest();
  }

  int _calculateRemainTime() {
    final timeDiff = _endTime - DateTime.now().millisecondsSinceEpoch;
    var result = (timeDiff / 1000).ceil();
    if (result < 0) {
      result = 0;
    }
    return result.toInt();
  }

  void setRemainTime(int seconds, {Color color = Colors.white}) {
    setState(() {
      remainTime = seconds;
    });
  }
}
