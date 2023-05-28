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
  Widget build(BuildContext context) {
    Provider.of<PlanInProgressProvider>(context, listen: false).index += 1;

    Navigator.of(context).pop();
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => new ExerciseInProgressScreen()));

    return Scaffold();
  }
}
