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
  runApp(ExerciseInProgress());
}

class ExerciseInProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exercise in progress',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ExerciseInProgressScreen(),
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

  void onFinishedButtonPressed() async {
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

  Text exerciseInfoFromExerciseInPlan(ExerciseInPlan exerciseInPlan) {
    String weight_str;
    double weight = exerciseInPlan.weight;

    String reps_str;
    int reps = exerciseInPlan.reps;

    if (weight <= 0) {
      // Weightless
      weight_str = "No weight";
    } else {
      weight_str = "Using ${weight}kg";
    }

    if (reps == -69) {
      // Until failure
      reps_str = "Until failure";
    } else {
      reps_str = "for ${reps} repetitions";
    }

    String result = '$weight_str ${reps_str}';

    return Text(result, style: TextStyle(fontSize: 20));
  }

  bool toggle = false;

  @override
  Widget build(BuildContext context) {
    int index =
        Provider.of<PlanInProgressProvider>(context, listen: false).index;

    int set_index =
        Provider.of<PlanInProgressProvider>(context, listen: false).set_index;

    List<ExerciseInPlan> exercisesInPlan =
        Provider.of<PlanInProgressProvider>(context, listen: false)
            .plan!
            .exercises;

    if (index >= exercisesInPlan.length) {
      debugPrint('Done!');

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
            SizedBox(height: 30),
            exerciseInfoFromExerciseInPlan(exerciseInPlan),
            SizedBox(height: 40),
            Text(
              'Tips: make sure to drink water often.',
              style: TextStyle(fontSize: 16),
            ),
            CountdownTimerWidget(
              durationInSeconds: 2,
              onInterval: handleInterval,
              onElapsed: handleElapsed,
            ),
            SizedBox(height: 40),
            if (toggle)
              ButtonTheme(
                minWidth: 250,
                height: 200,
                child: ElevatedButton(
                  onPressed: () => onFinishedButtonPressed(),
                  child: Text('Done!'),
                ),
              ),
            SizedBox(height: 200),
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Container(
                alignment: Alignment.bottomRight,
                child: Text("${set_index + 1} / ${exerciseInPlan.sets} sets",
                    style: TextStyle(fontSize: 12)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
