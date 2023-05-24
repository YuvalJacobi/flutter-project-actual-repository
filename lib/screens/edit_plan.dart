import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/model/plan.dart';
import 'package:flutter_complete_guide/provider/exercise_provider.dart';
import 'package:flutter_complete_guide/provider/plans_provider.dart';
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
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHFAD6nG4GX5NHYwDsmB8a_vwVY4DOxMqwPOiMVro&s');
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

  @override
  Widget build(BuildContext context) {
    Plan? _plan =
        Provider.of<PlanProvider>(context, listen: false).current_edited_plan;

    if (_plan == null) {
      return CircularProgressIndicator();
    }

    Plan plan = _plan;

    List<ExerciseInPlan> exercisesInPlan =
        Provider.of<PlanProvider>(context, listen: false)
            .current_edited_plan!
            .exercises;

    return Scaffold(
      appBar: AppBar(
        title: Text('Plan Editor'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: plan.exercises.length,
                  itemBuilder: (context, index) {
                    final option = plan.exercises[index];

                    // Each id is unique so the list will always contain 1 element assuming the id is valid.
                    Exercise exercise =
                        Provider.of<ExerciseProvider>(context, listen: false)
                            .getExercisesWithSorting(
                                id: option.exercise_id, active_muscles: [])[0];
                    return ListTile(
                      title: Text(exercise.name),
                      leading: imageFromExercise(exercise),
                    );
                  }),
              ReorderableListView.builder(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                shrinkWrap: true,
                itemCount: plan.exercises.length,
                itemBuilder: (context, index) {
                  final option = exercisesInPlan[index];

                  // Each id is unique so the list will always contain 1 element assuming the id is valid.
                  Exercise exercise =
                      Provider.of<ExerciseProvider>(context, listen: false)
                          .getExercisesWithSorting(
                              id: option.exercise_id, active_muscles: [])[0];

                  return ListTile(
                      key: Key(option.exercise_id +
                          option.plan_id +
                          index.toString()),
                      leading: imageFromExercise(exercise),
                      title: Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: [
                          Chip(
                            label: Text(
                              exercise.name,
                              style: TextStyle(fontSize: 12.0),
                            ),
                            backgroundColor: Colors.grey[300],
                            labelPadding: EdgeInsets.symmetric(horizontal: 8.0),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Text(
                                  'Active Muscles',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: exercise.active_muscles.length,
                                  itemBuilder: (context, index) {
                                    String item =
                                        exercise.active_muscles[index];
                                    return Chip(
                                      label: Text(
                                        item,
                                        style: TextStyle(fontSize: 12.0),
                                      ),
                                      backgroundColor: Colors.grey[300],
                                      labelPadding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          Chip(
                            label: Text(
                              "Level: " + exercise.level,
                              style: TextStyle(fontSize: 12.0),
                            ),
                            backgroundColor: Colors.grey[300],
                            labelPadding: EdgeInsets.symmetric(horizontal: 8.0),
                          ),
                          Chip(
                            label: Text(
                              "Category: " + exercise.category,
                              style: TextStyle(fontSize: 12.0),
                            ),
                            backgroundColor: Colors.grey[300],
                            labelPadding: EdgeInsets.symmetric(horizontal: 8.0),
                          ),
                        ],
                      ));
                },
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex -= 1;

                    ExerciseInPlan item = exercisesInPlan.removeAt(oldIndex);

                    exercisesInPlan.insert(newIndex, item);

                    Provider.of<PlanProvider>(context, listen: false)
                        .current_edited_plan!
                        .exercises = exercisesInPlan;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
