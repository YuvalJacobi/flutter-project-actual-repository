import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/provider/plans_provider.dart';
import 'package:flutter_complete_guide/screens/add_plan_screen.dart';
import 'package:flutter_complete_guide/screens/add_exercise_to_plan_screen.dart';
import 'package:provider/provider.dart';

import '../model/plan.dart';
import '../provider/user_provider.dart';

void main() {
  runApp(PlanApp());
}

class PlanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exercise Plans',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PlanScreen(),
    );
  }
}

class PlanScreen extends StatefulWidget {
  @override
  _PlanScreenState createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  List<Plan> plans = [];

  void startPlan(int index) {
    // Logic to start the exercise plan
    debugPrint('Starting plan: ${plans[index].name}');
  }

  void editPlan(int index) {
    debugPrint("Should navigate to edit screen");

    Provider.of<PlanProvider>(context, listen: true).current_edited_plan =
        plans[index];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlanEditorScreen(),
      ),
    );
  }

  void addPlan() {
    if (plans.length > 10) {
      debugPrint("Cannot have more than 10 plans!");
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlanAdderScreen(),
      ),
    );
  }

  void deletePlan(int index) {
    setState(() {
      plans.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<PlanProvider>(context, listen: true).current_edited_plan = null;

    plans = Provider.of<UserProvider>(context, listen: true).myUser.plans;

    return Scaffold(
      appBar: AppBar(
        title: Text('Plans'),
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
          Expanded(
            child: ListView.builder(
              itemCount: plans.length,
              itemBuilder: (context, index) {
                final _plan = plans[index];
                return PlanItem(
                  name: _plan.name,
                  onEditPressed: () => editPlan(index),
                  onDeletePressed: () => deletePlan(index),
                  onStartPressed: () => startPlan(index),
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
