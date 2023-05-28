import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/model/exercise_in_plan.dart';
import 'package:flutter_complete_guide/provider/exercise_provider.dart';
import 'package:flutter_complete_guide/provider/plan_in_progress_provider.dart';
import 'package:flutter_complete_guide/screens/home_screen.dart';
import 'package:flutter_complete_guide/screens/rest_screen.dart';
import 'package:provider/provider.dart';
import '../model/exercise.dart';
import 'countdown_timer.dart';

void main() {
  runApp(MyApp());
}

class ExerciseInProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exercise in progress',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ExerciseInProgress(),
    );
  }
}

class ExerciseInProgressScreen extends StatefulWidget {
  @override
  _ExerciseInProgressScreen createState() => _ExerciseInProgressScreen();
}

class _ExerciseInProgressScreen extends State<ExerciseInProgressScreen> {
  String textToShow = "";
  int secondsToShow = 5;
  Timer? timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  void onFinishedButtonPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CountdownScreen()),
    );
  }

  void handleInterval(int remainingSeconds) {
    debugPrint('Remaining time: $remainingSeconds');
  }

  void handleElapsed() {
    setState(() {
      toggle = true;
    });
  }

  bool toggle = false;

  @override
  Widget build(BuildContext context) {
    int index =
        Provider.of<PlanInProgressProvider>(context, listen: false).index;

    List<ExerciseInPlan> exercisesInPlan =
        Provider.of<PlanInProgressProvider>(context, listen: false)
            .plan!
            .exercises;

    if (index >= exercisesInPlan.length) {
      debugPrint('Done!');

      Navigator.of(context).pop();
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => new HomeScreen()));
    }
    ExerciseInPlan exerciseInPlan = exercisesInPlan[index];

    Exercise exercise = Provider.of<ExerciseProvider>(context, listen: false)
        .getExercisesWithSorting(
            id: exerciseInPlan.exercise_id, active_muscles: [])[0];

    textToShow = exercise.name;

    return Scaffold(
      appBar: AppBar(
        title: Text('Plan in progress'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              textToShow,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'Tips: make sure to drink water often.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            CountdownTimerWidget(
              durationInSeconds: 5,
              onInterval: handleInterval,
              onElapsed: handleElapsed,
            ),
            SizedBox(height: 20),
            if (toggle)
              ElevatedButton(
                onPressed: onFinishedButtonPressed,
                child: Text('Done!'),
              ),
          ],
        ),
      ),
    );
  }
}
