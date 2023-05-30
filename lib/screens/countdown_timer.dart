import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/provider/timer_elapsing.dart';
import 'package:provider/provider.dart';

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
  int remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<TimerElapsing>(context, listen: false).remaining_interval =
        widget.durationInSeconds;

    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    remainingSeconds = widget.durationInSeconds;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingSeconds > 0) {
          remainingSeconds--;
          Provider.of<TimerElapsing>(context, listen: false)
              .remaining_interval = remainingSeconds;
          widget.onInterval(remainingSeconds);
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
