import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/provider/plan_in_progress_provider.dart';
import 'package:flutter_complete_guide/screens/plan_in_progress_screen.dart';
import 'package:flutter_complete_guide/provider/timer_elapsing.dart';
import 'package:provider/provider.dart';

import '../model/exercise_in_plan.dart';
import '../model/plan.dart';
import 'countdown_timer.dart';

void main() {
  runApp(Countdown());
}

class Countdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rest timer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CountdownScreen(),
    );
  }
}

class CountdownScreen extends StatefulWidget {
  @override
  _CountdownScreenState createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  int _countdown = 0;
  Color _backgroundColor = Color.fromARGB(255, 144, 49, 47);

  void showNotification() {
    debugPrint('Rest time ended!');
  }

  void changeBackgroundColor() {
    setState(() {
      _backgroundColor = Colors.green;
    });
  }

  @override
  void initState() {
    super.initState();

    Plan plan =
        Provider.of<PlanInProgressProvider>(context, listen: false).plan!;

    int index =
        Provider.of<PlanInProgressProvider>(context, listen: false).index;

    ExerciseInPlan exerciseInPlan = plan.exercises[index];

    _countdown = exerciseInPlan.rest;

    debugPrint(
        "Countdown of exercise no.${index + 1}:" + _countdown.toString());

    countdown_timer = CountdownTimerWidget(
      durationInSeconds: _countdown,
      onInterval: handleInterval,
      onElapsed: handleElapsed,
    );
  }

  void handleInterval(int time) {
    setState(() {
      _countdown =
          Provider.of<TimerElapsing>(context, listen: false).remaining_interval;
    });
  }

  void handleElapsed() {
    changeBackgroundColor();
    showNotification();
  }

  Text countdown_to_text() {
    int minutes = _countdown ~/ 60;
    int seconds = (_countdown % 60);

    String minutes_str = minutes < 10 ? '0$minutes' : '$minutes';
    String seconds_str = seconds < 10 ? '0$seconds' : '$seconds';
    String time = '$minutes_str:$seconds_str';

    return Text(
      time,
      style: TextStyle(fontSize: 48, color: Colors.white),
    );
  }

  void skipCountdown() {
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => new PlanInProgressScreen()));
  }

  CountdownTimerWidget? countdown_timer = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Column(children: [
        countdown_timer!,
        Container(
            padding: EdgeInsets.only(top: 100),
            alignment: Alignment.center,
            child: Center(child: countdown_to_text())),
        Container(
          width: 150,
          height: 150,
          alignment: Alignment.bottomCenter,
          child: IconButton(
            icon: Icon(Icons.next_plan),
            onPressed: () => skipCountdown(),
          ),
        )
      ]),
    );
  }
}
