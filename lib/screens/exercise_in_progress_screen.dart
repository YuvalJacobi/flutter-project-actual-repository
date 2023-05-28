import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/model/exercise_in_plan.dart';
import 'package:flutter_complete_guide/provider/exercise_provider.dart';
import 'package:flutter_complete_guide/provider/plan_in_progress_provider.dart';
import 'package:flutter_complete_guide/screens/home_screen.dart';
import 'package:flutter_complete_guide/screens/rest_screen.dart';
import 'package:provider/provider.dart';

import '../model/exercise.dart';
import '../provider/exercise_in_plan_provider.dart';

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
    timer = Timer(Duration(seconds: secondsToShow), () {
      setState(() {
        textToShow = 'GO!';
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void onFinishedButtonPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CountdownScreen()),
    );
  }

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
            if (textToShow == 'GO!')
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
