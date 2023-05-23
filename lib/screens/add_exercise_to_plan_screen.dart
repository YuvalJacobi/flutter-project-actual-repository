import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/model/exercise.dart';
import 'package:flutter_complete_guide/model/exercise_in_plan.dart';
import 'package:flutter_complete_guide/provider/exercise_provider.dart';
import 'package:flutter_complete_guide/provider/plans_provider.dart';
import 'package:flutter_complete_guide/screens/plans_screen.dart';
import 'package:provider/provider.dart';

import '../model/plan.dart';

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
      home: PlanEditorScreen(),
    );
  }
}

class PlanEditorScreen extends StatefulWidget {
  @override
  _PlanEditorScreen createState() => _PlanEditorScreen();
}

class _PlanEditorScreen extends State<PlanEditorScreen> {
  final TextEditingController exerciseController = TextEditingController();
  final TextEditingController setsController = TextEditingController();
  final TextEditingController repsController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController restController = TextEditingController();
  List<Exercise> exerciseOptions = [];
  Plan? current_edited_plan = null;
  bool isInit = false;
  Exercise? selectedExercise = null;

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

  bool isExerciseValid(ExerciseInPlan exerciseInPlan) {
    if (exerciseInPlan.reps <= 0 ||
        exerciseInPlan.sets <= 0 ||
        exerciseInPlan.rest < 0 ||
        exerciseInPlan.weight < 0) return false;
    return true;
  }

  void clearSelections() {
    exerciseController.text = "";
    setsController.text = "";
    repsController.text = "";
    weightController.text = "";
    restController.text = "";
    selectedExercise = null;

    setState(() {});
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    debugPrint("trying to get current edited plan.");

    current_edited_plan = Provider.of<PlanProvider>(context, listen: false)
        .getCurrentEditedPlan();

    debugPrint("Successfully got current edited plan!" +
        current_edited_plan.toString());

    debugPrint("isInit: " + isInit.toString());

    exerciseOptions =
        Provider.of<ExerciseProvider>(context, listen: false).exercises;

    isInit = true;

    debugPrint("1isInit: " + isInit.toString());

    print("Exercises: " + exerciseOptions.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Exercise'),
      ),
      body: isInit == false
          ? CircularProgressIndicator()
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: exerciseController,
                      decoration: InputDecoration(
                        labelText: 'Exercise',
                      ),
                      onChanged: (text) {
                        setState(() => selectedExercise = null);
                      },
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Available exercises:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: exerciseOptions.length,
                      itemBuilder: (context, index) {
                        final option = exerciseOptions[index];
                        if (option.name
                            .toLowerCase()
                            .contains(exerciseController.text.toLowerCase())) {
                          return ListTile(
                            title: Text(option.name),
                            leading: imageFromExercise(option),
                            onTap: () {
                              setState(() {
                                exerciseController.text = option.name;
                                selectedExercise = option;
                              });
                            },
                          );
                        }
                        return SizedBox.shrink();
                      },
                    ),
                    SizedBox(height: 32.0),
                    TextField(
                      controller: weightController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Weight',
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: setsController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: false),
                      decoration: InputDecoration(
                        labelText: 'Sets',
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: repsController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: false),
                      decoration: InputDecoration(
                        labelText: 'Reps',
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextField(
                      controller: restController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Rest',
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        if (current_edited_plan == null) {
                          debugPrint("No plan is currently being edited!");
                          return;
                        }

                        if (selectedExercise == null) {
                          debugPrint("No exercise was selected!");
                          return;
                        }

                        ExerciseInPlan _exerciseInPlan = ExerciseInPlan(
                            exercise_id: selectedExercise!.id,
                            sets: int.parse(setsController.text),
                            reps: int.parse(repsController.text),
                            weight: double.parse(weightController.text),
                            rest: int.parse(restController.text),
                            plan_id: current_edited_plan!.id);

                        if (isExerciseValid(_exerciseInPlan) == false) {
                          debugPrint("Selections are not valid!");
                          return;
                        }
                        current_edited_plan!.exercises.add(_exerciseInPlan);

                        Provider.of<PlanProvider>(context, listen: false)
                            .current_edited_plan!
                            .exercises
                            .add(_exerciseInPlan);

                        debugPrint("Exercise was successfully added!\n\n" +
                            _exerciseInPlan.toString());

                        debugPrint("Current amount of exercises in plan: " +
                            current_edited_plan!.name +
                            ":\n" +
                            current_edited_plan!.exercises.length.toString());

                        clearSelections();

                        Navigator.of(context).pop();
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) =>
                                new PlanScreen()));
                      },
                      child: Text('Add'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
