import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/provider/plans_provider.dart';
import 'package:flutter_complete_guide/screens/add_plan_screen.dart';
import 'package:flutter_complete_guide/screens/plan_in_progress_screen.dart';
import 'package:provider/provider.dart';

import '../model/plan.dart';
import '../provider/plan_in_progress_provider.dart';
import '../provider/user_provider.dart';
import 'edit_plan_screen.dart';

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
    debugPrint('Starting plan: ${plans[index].name}');

    Plan p = plans[index];

    if (p.exercises_in_plan.isEmpty) {
      debugPrint('Plan is empty :(');
      return;
    }

    Provider.of<PlanInProgressProvider>(context, listen: false).plan = p;
    Provider.of<PlanInProgressProvider>(context, listen: false).index =
        -1; // since it adds 1 prematurely and I don't want to meddle with it.
    Provider.of<PlanInProgressProvider>(context, listen: false).set_index =
        -1; // since it adds 1 prematurely and I don't want to meddle with it.

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PlanInProgressScreen(),
      ),
    );
  }

  void editPlan(int index) {
    debugPrint("Should navigate to edit screen");
    plans = Provider.of<UserProvider>(context, listen: false).myUser.plans;

    Provider.of<PlanProvider>(context, listen: false)
        .setCurrentEditedPlanId(plans[index].id);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => EditPlanScreen(),
      ),
    );
  }

  void addPlan() {
    Provider.of<PlanProvider>(context, listen: false)
        .setCurrentEditedPlanId('');

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

  bool isInit = false;

  @override
  Widget build(BuildContext context) {
    if (isInit == false) {
      Provider.of<PlanProvider>(context, listen: false)
          .setCurrentEditedPlanId('');
    }

    Provider.of<UserProvider>(context, listen: false)
        .fetchUserData(context)
        .then((value) => plans =
            Provider.of<UserProvider>(context, listen: false).myUser.plans)
        .then((value) => {
              setState(() {
                isInit = true;
              })
            });

    return Scaffold(
      appBar: AppBar(
        title: Text('Plans'),
      ),
      body: isInit == false
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: addPlan,
                    child: Text('Add Plan'),
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    shrinkWrap: true,
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
              onPressed: () => onStartPressed(),
              icon: Icon(Icons.play_arrow),
            ),
            IconButton(
              onPressed: () => onEditPressed(),
              icon: Icon(Icons.edit),
            ),
          ],
        ),
      ),
    );
  }
}
