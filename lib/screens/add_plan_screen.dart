import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/model/plan.dart';
import 'package:flutter_complete_guide/model/user_profile.dart';
import 'package:flutter_complete_guide/provider/plans_provider.dart';
import 'package:flutter_complete_guide/provider/user_provider.dart';
import 'package:flutter_complete_guide/screens/edit_plan_screen.dart';
import 'package:flutter_complete_guide/screens/plans_screen.dart';
import 'package:provider/provider.dart';

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
                String _uid = Provider.of<UserProvider>(context, listen: false)
                    .myUser
                    .user_id;
                Provider.of<PlanProvider>(context, listen: false)
                        .current_edited_plan =
                    Plan(
                        exercises: [],
                        name: "New Plan #" + _plans.length.toString(),
                        user_id: _uid,
                        id: "");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlanEditorScreen(),
                  ),
                );
              },
              child: Text('Confirm'),
            ),
            ElevatedButton(
              onPressed: () {
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
