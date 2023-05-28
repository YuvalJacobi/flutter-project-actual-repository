import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/model/plan.dart';
import 'package:flutter_complete_guide/provider/exercise_provider.dart';
import 'package:flutter_complete_guide/provider/plans_provider.dart';
import 'package:flutter_complete_guide/screens/add_exercise_to_plan_screen.dart';
import 'package:provider/provider.dart';

import '../model/exercise.dart';
import '../model/exercise_in_plan.dart';

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
      home: EditPlanScreen(),
    );
  }
}

class EditPlanScreen extends StatefulWidget {
  @override
  _EditPlanScreen createState() => _EditPlanScreen();
}

class _EditPlanScreen extends State<EditPlanScreen> {
  Image imageFromExercise(Exercise exercise) {
    if (exercise.image_url.isEmpty) {
      // return white square
      return Image.network(
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHFAD6nG4GX5NHYwDsmB8a_vwVY4DOxMqwPOiMVro&s',
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      );
    }
    return Image.network(
      exercise.image_url,
      width: 100,
      height: 100,
      fit: BoxFit.cover,
    );
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  List<ExerciseInPlan> exercisesInPlan = [];

  Widget myExercisesWidget() {
    return Center(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: exercisesInPlan.length,
        itemBuilder: (context, index) {
          ExerciseInPlan exerciseInPlan = exercisesInPlan[index];
          Exercise exercise =
              Provider.of<ExerciseProvider>(context, listen: false)
                  .getExercisesWithSorting(
                      id: exerciseInPlan.exercise_id, active_muscles: [])[0];

          String weight_representation;

          if (exerciseInPlan.weight == 0 || exerciseInPlan == -1) {
            weight_representation = "Weightless";
          } else if (exerciseInPlan.weight == -69) // failure
          {
            weight_representation = "To failure";
          } else {
            weight_representation = exerciseInPlan.weight.toString() + 'kg';
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Row(
                children: [
                  Container(
                    child: Expanded(
                      child: Flexible(
                        child: imageFromExercise(exercise), // img
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    alignment: Alignment.center,
                    child: Expanded(
                      child: Flexible(
                        child: Text(
                          exercise.name,
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ), // name
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    alignment: Alignment.center,
                    child: Expanded(
                      child: Flexible(
                        child: Text(
                          exerciseInPlan.sets.toString() + ' sets',
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ), // sets
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    alignment: Alignment.center,
                    child: Expanded(
                      child: Flexible(
                        child: Text(
                          exerciseInPlan.reps.toString() + ' reps',
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ), // reps
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Container(
                    alignment: Alignment.center,
                    child: Expanded(
                      child: Flexible(
                        child: Text(
                          weight_representation,
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void addExercise() {
    Navigator.of(context).pop();
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => new PlanEditorScreen()));
  }

  @override
  Widget build(BuildContext context) {
    Plan? _plan =
        Provider.of<PlanProvider>(context, listen: false).current_edited_plan;

    if (_plan == null) {
      return Center(child: CircularProgressIndicator());
    }

    exercisesInPlan = Provider.of<PlanProvider>(context, listen: false)
        .current_edited_plan!
        .exercises;

    return Scaffold(
        appBar: AppBar(
          title: Text('Plan Editor'),
        ),
        body: ListView(
          children: [
            exercisesInPlan.length == 0 ? Center() : myExercisesWidget(),
            SizedBox(height: 15),
            Container(
                alignment: Alignment.topLeft,
                child: ElevatedButton(
                    child: Text(
                      "Add exercise",
                    ),
                    onPressed: addExercise))
          ],
        ));
  }
}
