import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/model/user_profile.dart';
import 'package:flutter_complete_guide/provider/plans_provider.dart';
import 'package:provider/provider.dart';

import '../model/exercise.dart';
import '../model/plan.dart';
import '../provider/user_provider.dart';

void main() {
  runApp(ExercisePlanApp());
}

class ExercisePlanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exercise Plans',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ExercisePlanScreen(),
    );
  }
}

class ExercisePlanScreen extends StatefulWidget {
  @override
  _ExercisePlanScreenState createState() => _ExercisePlanScreenState();
}

class _ExercisePlanScreenState extends State<ExercisePlanScreen> {
  List<Plan> plans = [];

  void startExercisePlan(int index) {
    // Logic to start the exercise plan
    print('Starting plan: ${plans[index].name}');
  }

  void editExercisePlan(int index) {
    // Redirect to EditScreen with the corresponding Exercise
    //Navigator.push(
    //context,
    //MaterialPageRoute(
    //builder: (context) => EditScreen(exercise: exercisePlans[index]),
    //),
    //);

    print("Should navigate to edit screen");
  }

  void addPlan() {}

  void startPlan() {}

  void deletePlan(int index) {
    setState(() {
      plans.removeAt(index);
    });
  }

  void editPlan(int index) {
    // Open edit screen with plan.
  }

  @override
  Widget build(BuildContext context) {
    plans = Provider.of<UserProfile>(context, listen: true).plans;

    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise Plans'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: addPlan,
              child: Text('Add Plan'),
            ),
          ),
          ElevatedButton(
            onPressed: () =>
                startExercisePlan(0), // Placeholder for play button
            child: Text('Play'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: plans.length,
              itemBuilder: (context, index) {
                final _plan = plans[index];
                return PlanItem(
                  onEditPressed: () => editPlan(index),
                  onDeletePressed: () => deletePlan(index),
                  name: _plan.name,
                  onStartPressed: () => startPlan(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PlanItem extends StatelessWidget {
  final String name;
  final VoidCallback onStartPressed;
  final VoidCallback onEditPressed;

  const PlanItem({
    required this.name,
    required this.onStartPressed,
    required this.onEditPressed,
    required void Function() onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onStartPressed,
              icon: Icon(Icons.play_arrow),
            ),
            IconButton(
              onPressed: onEditPressed,
              icon: Icon(Icons.edit),
            ),
          ],
        ),
      ),
    );
  }
}
