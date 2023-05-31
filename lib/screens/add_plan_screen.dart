import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/model/plan.dart';
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

Future<void> manualDelay() async {
  Future.wait([delay()]);
}

Future<void> delay() async {
  await Future.delayed(const Duration(seconds: 5));
  return;
}

class PlanAdderScreen extends StatefulWidget {
  @override
  _PlanAdderScreen createState() => _PlanAdderScreen();
}

class _PlanAdderScreen extends State<PlanAdderScreen> {
  final TextEditingController nameController = TextEditingController();

  bool isInit = false;

  @override
  Widget build(BuildContext context) {
    Provider.of<PlanProvider>(context, listen: false)
        .fetchPlans(context)
        .then((value) => {
              setState(() {
                isInit = true;
              })
            });

    return Scaffold(
      appBar: AppBar(
        title: Text('Plan Adder'),
      ),
      body: isInit == false
          ? Center(child: CircularProgressIndicator())
          : Center(
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
                      // move to provider
                      List<Plan> _my_plans =
                          Provider.of<UserProvider>(context, listen: false)
                              .myUser
                              .plans;

                      if (_my_plans
                          .map((e) => e.name)
                          .contains(nameController.text)) {
                        debugPrint('A plan with the same name already exists!');
                        return;
                      }

                      String _uid =
                          Provider.of<UserProvider>(context, listen: false)
                              .myUser
                              .user_id;

                      Plan p = Plan(
                          exercises_in_plan: [],
                          name: nameController.text,
                          user_id: _uid,
                          id: "");

                      Provider.of<PlanProvider>(context, listen: false)
                          .addData(p, context)
                          .then((_) => {
                                p = Provider.of<PlanProvider>(context,
                                        listen: false)
                                    .getPlanByName(nameController.text),
                                Provider.of<UserProvider>(context,
                                        listen: false)
                                    .updatePlanOfUser(p),
                                Provider.of<PlanProvider>(context,
                                        listen: false)
                                    .updateCurrentEditedPlan(p),
                                Provider.of<PlanProvider>(context,
                                        listen: false)
                                    .setCurrentEditedPlanId(p.id),
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditPlanScreen(),
                                  ),
                                )
                              });

                      // adding manual delay since await doesn't wait for some reason
                      //manualDelay();

                      // try {
                      //   p = Provider.of<PlanProvider>(context, listen: false)
                      //       .plans
                      //       .last;

                      //   if (p.name != nameController.text) {
                      //     // wrong plan was used (last one)

                      //     Provider.of<PlanProvider>(context, listen: false)
                      //         .deletePlanByName(nameController.text);
                      //     return;
                      //   }
                      // } on Error catch (_) {
                      //   return;
                      // }
                    },
                    child: Text('Confirm'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
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
