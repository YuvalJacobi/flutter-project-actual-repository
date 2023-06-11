import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/exercise_in_progress_screen.dart';
import 'package:provider/provider.dart';

import '../provider/plan_in_progress_provider.dart';

void main() {
  runApp(PlanInProgress());
}

class PlanInProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plan in progress',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PlanInProgressScreen(),
    );
  }
}

class PlanInProgressScreen extends StatefulWidget {
  @override
  _PlanInProgressScreen createState() => _PlanInProgressScreen();
}

class _PlanInProgressScreen extends State<PlanInProgressScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      navigateToExerciseInProgressScreen();
    });
  }

  void navigateToExerciseInProgressScreen() {
    /// sets set_index to 0
    Provider.of<PlanInProgressProvider>(context, listen: false).set_index = 0;

    /// increments index of exercise by 1
    Provider.of<PlanInProgressProvider>(context, listen: false).index += 1;

    /// navigate to exercise in progress screen.
    Future.delayed(
      Duration.zero,
      () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => ExerciseInProgressScreen(),
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center();
  }
}
