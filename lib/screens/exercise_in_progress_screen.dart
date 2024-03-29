import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/model/exercise_in_plan.dart';
import 'package:flutter_complete_guide/provider/exercise_in_plan_provider.dart';
import 'package:flutter_complete_guide/provider/exercise_provider.dart';
import 'package:flutter_complete_guide/provider/plan_in_progress_provider.dart';
import 'package:flutter_complete_guide/screens/home_screen.dart';
import 'package:flutter_complete_guide/screens/rest_screen.dart';
import 'package:provider/provider.dart';
import '../model/exercise.dart';
import '../widgets/countdown_timer.dart';

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
    Navigator.pushReplacement(
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

    if (reps == 0) {
      // Until failure
      reps_str = "Until failure";
    } else {
      reps_str = "for ${reps} repetitions";
    }

    String result = '$weight_str ${reps_str}';

    return Text(result, style: TextStyle(fontSize: 20));
  }

  Image imageFromExercise(Exercise exercise, double width, double height) {
    /// returns image of exercise if the image_url is non-null.
    if (exercise.image_url.isEmpty) {
      // return white square
      return Image.network(
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHFAD6nG4GX5NHYwDsmB8a_vwVY4DOxMqwPOiMVro&s');
    }

    /// return image of exercise from the network.
    return Image.network(
      exercise.image_url,
      width: width,
      height: height,
      fit: BoxFit.cover,
    );
  }

  bool toggle = false;

  @override
  Widget build(BuildContext context) {
    /// get index of current plan
    int index =
        Provider.of<PlanInProgressProvider>(context, listen: false).index;

    /// get index of current set
    int set_index =
        Provider.of<PlanInProgressProvider>(context, listen: false).set_index;

    /// get the ids of current exercises in plan
    List<String> exercisesInPlanIds =
        Provider.of<PlanInProgressProvider>(context, listen: false)
            .plan!
            .exercises_in_plan;

    /// get exercises in current plan
    List<ExerciseInPlan> exercisesInPlan =
        Provider.of<ExerciseInPlanProvider>(context, listen: false)
            .exercisesInPlanByIds(exercisesInPlanIds);

    /// check if last exercise was done
    if (index >= exercisesInPlan.length) {
      debugPrint('Done!');

      Provider.of<PlanInProgressProvider>(context, listen: false).Clear();

      /// navigate back to home screen
      Future.delayed(
          Duration.zero,
          () => {
                Navigator.of(context).pushReplacement(new MaterialPageRoute(
                    builder: (BuildContext context) => new HomeScreen()))
              });
    }

    /// get current exercise in plan
    ExerciseInPlan exerciseInPlan = exercisesInPlan[index];

    /// retrieve exercise component from it
    Exercise exercise = Provider.of<ExerciseProvider>(context, listen: false)
        .getExercisesWithSorting(
            exercise_id: exerciseInPlan.exercise_id, active_muscles: [])[0];

    textToShow = exercise.name;

    /// return visual representation of screen.
    return Scaffold(
      appBar: AppBar(
        title: Text('Plan in progress'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  textToShow,
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            SizedBox(height: 30),
            exerciseInfoFromExerciseInPlan(exerciseInPlan),
            SizedBox(height: 40),
            SizedBox(
              width: 200,
              height: 200,
              child: FittedBox(
                  fit: BoxFit.fill,
                  child: imageFromExercise(exercise, 150, 150)),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                width: 500,
                alignment: Alignment.center,
                child: Text(
                  'Tips: make sure to drink water often.\n\nmachines at the gym are NOT parking in tel-aviv, don\'t just place your towel and leave.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            CountdownTimerWidget(
              durationInSeconds: 2,
              onInterval: handleInterval,
              onElapsed: handleElapsed,
            ),
            SizedBox(height: 40),
            if (toggle)
              SizedBox(
                width: 200,
                height: 100,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent),
                  onPressed: () => onFinishedButtonPressed(),
                  child: Text(
                    'Done!',
                    style: TextStyle(fontSize: 32),
                  ),
                ),
              ),
            SizedBox(height: 25),
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
