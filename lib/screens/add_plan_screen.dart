import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/model/plan.dart';
import 'package:flutter_complete_guide/provider/plans_provider.dart';
import 'package:flutter_complete_guide/provider/user_provider.dart';
import 'package:flutter_complete_guide/screens/plans_screen.dart';
import 'package:provider/provider.dart';

import 'edit_plan_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plan Editor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PlanAdderScreen(),
    );
  }
}

class PlanAdderScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Provider.of<PlanProvider>(context, listen: false).fetchPlans();

    return Scaffold(
      appBar: AppBar(
        title: Text('Plan Adder'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Enter name of plan to create',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                List<Plan> _plans =
                    Provider.of<UserProvider>(context, listen: false)
                        .myUser
                        .plans;

                if (_plans.map((e) => e.name).contains(nameController.text)) {
                  debugPrint('A plan with the same name already exists!');
                  return;
                }

                String _uid = Provider.of<UserProvider>(context, listen: false)
                    .myUser
                    .user_id;

                Plan p = Plan(
                    exercises: [],
                    name: nameController.text,
                    user_id: _uid,
                    id: "");

                Provider.of<PlanProvider>(context, listen: false).addData(p);

                p = Provider.of<PlanProvider>(context, listen: false)
                    .getPlans
                    .last;

                Provider.of<UserProvider>(context, listen: false)
                    .updatePlanOfUser(p);

                Provider.of<PlanProvider>(context, listen: false)
                        .current_edited_plan =
                    Provider.of<UserProvider>(context, listen: false)
                        .myUser
                        .plans
                        .last;

                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditPlanScreen(),
                  ),
                );
              },
              child: Text('Confirm'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlanScreen(),
                  ),
                );
              },
              child: Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
