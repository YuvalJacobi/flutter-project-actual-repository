import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/plan_in_progress_screen.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../model/exercise_in_plan.dart';
import '../provider/exercise_in_plan_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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

  void startCountdown() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          timer.cancel();
          _showNotification();
          _changeBackgroundColor();
        }
      });
    });
  }

  void _showNotification() {
    print('Rest time ended!');
  }

  void _changeBackgroundColor() {
    setState(() {
      _backgroundColor = Colors.green;
    });
  }

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  Text countdown_to_text() {
    int minutes = (_countdown / 60) as int;
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
    Navigator.of(context).pop();
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => new PlanInProgressScreen()));
  }

  @override
  Widget build(BuildContext context) {
    ExerciseInPlan exerciseInPlan =
        Provider.of<ExerciseInPlanProvider>(context, listen: false)
            .current_played_exercise_in_plan!;

    _countdown = exerciseInPlan.rest;

    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Column(children: [
        Center(child: countdown_to_text()),
        Container(
          width: 150,
          height: 150,
          alignment: Alignment.bottomCenter,
          child: IconButton(
            icon: Icon(Icons.skip_next),
            onPressed: skipCountdown,
          ),
        )
      ]),
    );
  }
}
