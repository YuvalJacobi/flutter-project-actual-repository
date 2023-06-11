import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/provider/plans_provider.dart';
import 'package:flutter_complete_guide/screens/add_plan_screen.dart';
import 'package:flutter_complete_guide/screens/home_screen.dart';
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
  /// variable which stores the plans of the user.
  List<Plan> plans = [];

  void startPlan(int index) {
    debugPrint('Starting plan: ${plans[index].name}');

    /// get current plan which the user started.
    Plan p = plans[index];

    if (p.exercises_in_plan.isEmpty) {
      debugPrint('Plan is empty :(');
      return;
    }

    Provider.of<PlanInProgressProvider>(context, listen: false).start =
        DateTime.now();

    /// set current played plan
    Provider.of<PlanInProgressProvider>(context, listen: false).plan = p;

    /// set index to -1 since it increments anyway when entering the starting screen.
    Provider.of<PlanInProgressProvider>(context, listen: false).index = -1;

    /// set set_index to -1 since it increments anyway when entering the starting screen.
    Provider.of<PlanInProgressProvider>(context, listen: false).set_index = -1;

    /// go to plan in progress screen
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

    /// set the current edited plan
    Provider.of<PlanProvider>(context, listen: false)
        .setCurrentEditedPlanId(plans[index].id);

    /// go to plan editing screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => EditPlanScreen(),
      ),
    );
  }

  void addPlan() {
    /// delete reference to current edited plan
    Provider.of<PlanProvider>(context, listen: false)
        .setCurrentEditedPlanId('');

    /// go to plan adding screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PlanAdderScreen(),
      ),
    );
  }

  void deletePlan(int index) {
    /// show dialog for confirmation of deletion
    showDialog(
        context: context,
        builder: ((ctx) => AlertDialog(
              title: Text('Delete Plan'),
              content: Text(
                'WARNING: This action will permanently delete this plan',
                textAlign: TextAlign.center,
              ),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                ),
                TextButton(
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.red.shade800),
                  ),
                  onPressed: () {
                    Provider.of<PlanProvider>(context, listen: false)
                        .deletePlanInUser(plans[index], context)
                        .then((value) => {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlanScreen(),
                                ),
                              )
                            });
                  },
                )
              ],
            )));
  }

  bool isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Provider.of<UserProvider>(context, listen: false)
        .fetchUserData(context)
        .then((value) => plans =
            Provider.of<UserProvider>(context, listen: false).myUser.plans)
        .then((value) => {
              setState(() {
                isInit = true;
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    /// return UI elements which represent the screen
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
                  child: plans.length == 0
                      ? Container(
                          alignment: Alignment.center,
                          child: Text('You have no plans :(',
                              style: TextStyle(fontSize: 20)))
                      : ListView.builder(
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
                SizedBox(height: 150),
                ElevatedButton(
                    onPressed: () => {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                          )
                        },
                    child: Text(
                      'Close',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ))
              ],
            ),
    );
  }
}

class PlanItem extends StatelessWidget {
  final String name;
  final VoidCallback onStartPressed;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  const PlanItem({
    required this.name,
    required this.onStartPressed,
    required this.onEditPressed,
    required this.onDeletePressed,
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
            IconButton(
              onPressed: () => onDeletePressed(),
              icon: Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
