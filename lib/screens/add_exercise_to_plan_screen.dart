import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/model/exercise.dart';
import 'package:flutter_complete_guide/model/exercise_in_plan.dart';
import 'package:flutter_complete_guide/provider/exercise_in_plan_provider.dart';
import 'package:flutter_complete_guide/provider/exercise_provider.dart';
import 'package:flutter_complete_guide/provider/plans_provider.dart';
import 'package:flutter_complete_guide/provider/user_provider.dart';
import 'package:numberpicker/numberpicker.dart';
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

final TextEditingController exerciseController = TextEditingController();
final TextEditingController setsController = TextEditingController();
final TextEditingController repsController = TextEditingController();
final TextEditingController weightController = TextEditingController();
final TextEditingController restController = TextEditingController();
Exercise? selectedExercise = null;
Plan? current_edited_plan = null;

class _PlanEditorScreen extends State<PlanEditorScreen> {
  List<Exercise> exerciseOptions = [];

  bool isInit = false;

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

  ExerciseInPlan getExerciseInPlanFromControllers(
      String exercise_id, String plan_id) {
    try {
      if (isExerciseValid(ExerciseInPlan(
              sets: int.parse(setsController.text),
              reps: int.parse(repsController.text),
              weight: double.parse(weightController.text),
              rest: int.parse(restController.text),
              exercise_id: exercise_id,
              plan_id: plan_id)) ==
          false)
        return ExerciseInPlan(
            sets: -1,
            reps: -1,
            weight: -1,
            rest: -1,
            exercise_id: '',
            plan_id: '');

      return ExerciseInPlan(
          sets: int.parse(setsController.text),
          reps: int.parse(repsController.text),
          weight: double.parse(weightController.text),
          rest: int.parse(restController.text),
          exercise_id: exercise_id,
          plan_id: plan_id);
    } catch (e) {
      return ExerciseInPlan(
          sets: -1,
          reps: -1,
          weight: -1,
          rest: -1,
          exercise_id: '',
          plan_id: '');
    }
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

    Provider.of<ExerciseProvider>(context, listen: false).fetchExercises();

    exerciseOptions =
        Provider.of<ExerciseProvider>(context, listen: false).exercises;

    isInit = true;

    debugPrint("1isInit: " + isInit.toString());

    print("Exercises: " + exerciseOptions.toString());
  }

  @override
  Widget build(BuildContext context) {
    String uid = Provider.of<UserProvider>(context, listen: false).getUserId();
    Provider.of<ExerciseProvider>(context, listen: true).fetchExercises();
    Plan current_edited_plan = Provider.of<PlanProvider>(context, listen: true)
        .getCurrentEditedPlan()!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Exercise'),
      ),
      body: isInit == false
          ? CircularProgressIndicator()
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.0),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: exerciseOptions.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: 200,
                        height: 400,
                        child: CardWidget(
                          exercise: exerciseOptions[index],
                          imageUrl: exerciseOptions[index].image_url,
                          key: Key(exerciseOptions[index].exercise_id),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 32.0),
                  // TextField(
                  //   controller: weightController,
                  //   keyboardType:
                  //       TextInputType.numberWithOptions(decimal: true),
                  //   decoration: InputDecoration(
                  //     labelText: 'Weight',
                  //   ),
                  // ),
                  // Column(
                  //   children: [
                  //     Text(
                  //       'Weight:',
                  //       style: TextStyle(fontSize: 16),
                  //     ),
                  //     DecimalNumberPicker(
                  //         value: weightController.text.isEmpty
                  //             ? 0
                  //             : double.parse(weightController.text),
                  //         minValue: 0,
                  //         maxValue: 500,
                  //         selectedTextStyle: TextStyle(fontSize: 12),
                  //         textStyle: TextStyle(fontSize: 8),
                  //         onChanged: (value) => setState(() {
                  //               weightController.text = value.toString();
                  //             })),
                  //   ],
                  // ),
                  // SizedBox(height: 16.0),
                  // // TextField(
                  // //   controller: setsController,
                  // //   keyboardType:
                  // //       TextInputType.numberWithOptions(decimal: false),
                  // //   decoration: InputDecoration(
                  // //     labelText: 'Sets',
                  // //   ),
                  // // ),
                  // Column(
                  //   children: [
                  //     Text(
                  //       'Sets:',
                  //       style: TextStyle(fontSize: 16),
                  //     ),
                  //     NumberPicker(
                  //         value: setsController.text.isEmpty
                  //             ? 0
                  //             : int.parse(setsController.text),
                  //         minValue: 0,
                  //         maxValue: 50,
                  //         selectedTextStyle: TextStyle(fontSize: 12),
                  //         textStyle: TextStyle(fontSize: 8),
                  //         onChanged: (value) => setState(() {
                  //               setsController.text = value.toString();
                  //             })),
                  //   ],
                  // ),
                  // SizedBox(height: 16.0),
                  // // TextField(
                  // //   controller: repsController,
                  // //   keyboardType:
                  // //       TextInputType.numberWithOptions(decimal: false),
                  // //   decoration: InputDecoration(
                  // //     labelText: 'Reps',
                  // //   ),
                  // // ),
                  // Column(
                  //   children: [
                  //     Text(
                  //       'Reps:',
                  //       style: TextStyle(fontSize: 16),
                  //     ),
                  //     NumberPicker(
                  //         value: repsController.text.isEmpty
                  //             ? 0
                  //             : int.parse(repsController.text),
                  //         minValue: 0,
                  //         maxValue: 100,
                  //         selectedTextStyle: TextStyle(fontSize: 12),
                  //         textStyle: TextStyle(fontSize: 8),
                  //         onChanged: (value) => setState(() {
                  //               repsController.text = value.toString();
                  //             })),
                  //   ],
                  // ),
                  // SizedBox(height: 16.0),
                  // // TextField(
                  // //   controller: restController,
                  // //   keyboardType: TextInputType.number,
                  // //   decoration: InputDecoration(
                  // //     labelText: 'Rest',
                  // //   ),
                  // // ),
                  // Column(
                  //   children: [
                  //     Text(
                  //       'Rest:',
                  //       style: TextStyle(fontSize: 16),
                  //     ),
                  //     NumberPicker(
                  //         value: restController.text.isEmpty
                  //             ? 0
                  //             : int.parse(restController.text),
                  //         minValue: 0,
                  //         maxValue: 600,
                  //         selectedTextStyle: TextStyle(fontSize: 12),
                  //         textStyle: TextStyle(fontSize: 8),
                  //         onChanged: (value) => setState(() {
                  //               restController.text = value.toString();
                  //             })),
                  //   ],
                  // ),
                  // SizedBox(height: 16.0),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     if (current_edited_plan == null) {
                  //       debugPrint("No plan is currently being edited!");

                  //       return;
                  //     }

                  //     if (selectedExercise == null) {
                  //       debugPrint("No exercise was selected!");
                  //       return;
                  //     }

                  //     ExerciseInPlan _exerciseInPlan = ExerciseInPlan(
                  //         exercise_id: selectedExercise!.exercise_id,
                  //         sets: int.parse(setsController.text),
                  //         reps: int.parse(repsController.text),
                  //         weight: double.parse(weightController.text),
                  //         rest: int.parse(restController.text),
                  //         plan_id: current_edited_plan!.id);

                  //     if (isExerciseValid(_exerciseInPlan) == false) {
                  //       debugPrint("Selections are not valid!");
                  //       return;
                  //     }
                  //     current_edited_plan!.exercises.add(_exerciseInPlan);

                  //     Provider.of<PlanProvider>(context, listen: false)
                  //         .current_edited_plan = current_edited_plan;

                  //     debugPrint("Exercise was successfully added!\n\n" +
                  //         _exerciseInPlan.toString());

                  //     debugPrint("Current amount of exercises in plan: " +
                  //         current_edited_plan!.name +
                  //         ":\n" +
                  //         current_edited_plan!.exercises.length.toString());

                  //     Provider.of<UserProvider>(context, listen: false)
                  //         .updatePlanOfUser(current_edited_plan!);

                  //     clearSelections();

                  //     Navigator.of(context).pop();
                  //   },
                  //   child: Text('Add'),
                  // ),
                ],
              ),
            ),
    );
  }
}

class CardWidget extends StatefulWidget {
  final Exercise exercise;
  final String imageUrl;

  const CardWidget(
      {required Key key, required this.exercise, required this.imageUrl})
      : super(key: key);

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
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

  ExerciseInPlan getExerciseInPlanFromControllers(
      String exercise_id, String plan_id) {
    try {
      if (isExerciseValid(ExerciseInPlan(
              sets: int.parse(setsController.text),
              reps: int.parse(repsController.text),
              weight: double.parse(weightController.text),
              rest: int.parse(restController.text),
              exercise_id: exercise_id,
              plan_id: plan_id)) ==
          false)
        return ExerciseInPlan(
            sets: -1,
            reps: -1,
            weight: -1,
            rest: -1,
            exercise_id: '',
            plan_id: '');

      return ExerciseInPlan(
          sets: int.parse(setsController.text),
          reps: int.parse(repsController.text),
          weight: double.parse(weightController.text),
          rest: int.parse(restController.text),
          exercise_id: exercise_id,
          plan_id: plan_id);
    } catch (e) {
      return ExerciseInPlan(
          sets: -1,
          reps: -1,
          weight: -1,
          rest: -1,
          exercise_id: '',
          plan_id: '');
    }
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

  void save() {
    setState(() {});
  }

  String activeMusclesRepresentation() {
    String result = '';
    for (String s in widget.exercise.active_muscles) {
      result += s + '\n';
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.exercise.name,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Active Muscles',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    activeMusclesRepresentation(),
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        constraints: BoxConstraints(
                            minWidth: 500,
                            maxWidth: 550,
                            minHeight: 525,
                            maxHeight: 525),
                        alignment: Alignment.bottomLeft,
                        child: PopupMenuButton(
                          onOpened: () {
                            clearSelections();
                          },
                          onCanceled: () {},
                          onSelected: (value) {
                            exerciseController.text = widget.exercise.name;
                          },
                          child: Text(
                            'Add',
                            style: TextStyle(fontSize: 20),
                          ),
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                child: TextField(
                                  controller: setsController,
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: false),
                                  decoration: InputDecoration(
                                    labelText: 'Sets',
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                child: TextField(
                                  controller: repsController,
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: false),
                                  decoration: InputDecoration(
                                    labelText: 'Reps',
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                child: TextField(
                                  controller: weightController,
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true),
                                  decoration: InputDecoration(
                                    labelText: 'Weight',
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                child: TextField(
                                  controller: restController,
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: false),
                                  decoration: InputDecoration(
                                    labelText: 'Rest',
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                  child: ElevatedButton(
                                child: Text(
                                  'Confirm',
                                  style: TextStyle(fontSize: 20),
                                ),
                                onPressed: () {
                                  if ( //Provider.of<ExerciseInPlanProvider>(
                                      //             context,
                                      //             listen: false)
                                      //         .Validate(
                                      //             option, uid, context) ==
                                      true) {
                                    Provider.of<ExerciseInPlanProvider>(context,
                                            listen: false)
                                        .addData(
                                            getExerciseInPlanFromControllers(
                                                widget.exercise.exercise_id,
                                                current_edited_plan!.id));
                                    Navigator.pop(context);
                                  }
                                },
                              ))
                            ];
                          },
                        ),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
