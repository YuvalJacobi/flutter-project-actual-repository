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
  // timer instance
  late Timer _timer;

  // remaining seconds variable
  int remainingSeconds = 0;

  @override
  void initState() {
    super.initState();

    // set remaining interval
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
    // starting counting.

    // get remaining seconds
    remainingSeconds = widget.durationInSeconds;

    // update each second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        // check if time is up
        if (remainingSeconds > 0) {
          // timer is still active, decrement time variable by 1 both locally and globally, call onInterval() with remaining seconds.
          remainingSeconds--;
          Provider.of<TimerElapsing>(context, listen: false)
              .remaining_interval = remainingSeconds;
          widget.onInterval(remainingSeconds);
        } else {
          // time is up! cancel timer and call the elapsed method.
          _timer.cancel();
          widget.onElapsed();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // return empty UI element.
    return Center();
  }
}
