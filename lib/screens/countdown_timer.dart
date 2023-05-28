import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimerWidget extends StatefulWidget {
  final int durationInSeconds;
  final Function(int) onInterval;
  final Function() onElapsed;

  CountdownTimerWidget({
    required this.durationInSeconds,
    required this.onInterval,
    required this.onElapsed,
  });

  @override
  _CountdownTimerWidgetState createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget> {
  late Timer _timer;
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    _remainingSeconds = widget.durationInSeconds;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          widget.onInterval(_remainingSeconds);
        } else {
          _timer.cancel();
          widget.onElapsed();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center();
  }
}
