import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/model/exercise.dart';
import 'package:flutter_complete_guide/model/exercise_in_plan.dart';
import 'package:flutter_complete_guide/provider/exercise_in_plan_provider.dart';
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

/// text controllers of all properties of an exercise.
final TextEditingController exerciseController = TextEditingController();
final TextEditingController setsController = TextEditingController();
final TextEditingController repsController = TextEditingController();
final TextEditingController weightController = TextEditingController();
final TextEditingController restController = TextEditingController();

/// local variables
Exercise? selectedExercise = null;
Plan? current_edited_plan = null;

class _PlanEditorScreen extends State<PlanEditorScreen> {
  List<Exercise> exerciseOptions = [];
  String nameFilter = '';

  bool isInit = false;

  Image imageFromExercise(Exercise exercise) {
    /// get image of exercise fron network if image-url is non-null.
    if (exercise.image_url.isEmpty) {
      // return white square
      return Image.network(
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHFAD6nG4GX5NHYwDsmB8a_vwVY4DOxMqwPOiMVro&s');
    }

    /// return image from network.
    return Image.network(
      exercise.image_url,
      width: 100,
      height: 100,
      fit: BoxFit.cover,
    );
  }

  ExerciseInPlan getExerciseInPlanFromControllers(
      String exercise_id, String plan_id) {
    /// return exercise in plan from exercise id and plan id with a validity check.
    try {
      if (isExerciseValid(ExerciseInPlan(
              sets: int.parse(setsController.text),
              reps: int.parse(repsController.text),
              weight: double.parse(weightController.text),
              rest: int.parse(restController.text),
              exercise_id: exercise_id,
              plan_id: plan_id,
              exercise_in_plan_id: '')) ==
          false)
        return ExerciseInPlan(
            sets: -1,
            reps: -1,
            weight: -1,
            rest: -1,
            exercise_id: '',
            plan_id: '',
            exercise_in_plan_id: '');

      return ExerciseInPlan(
          sets: int.parse(setsController.text),
          reps: int.parse(repsController.text),
          weight: double.parse(weightController.text),
          rest: int.parse(restController.text),
          exercise_id: exercise_id,
          plan_id: plan_id,
          exercise_in_plan_id: '');
    } catch (e) {
      return ExerciseInPlan(
          sets: -1,
          reps: -1,
          weight: -1,
          rest: -1,
          exercise_id: '',
          plan_id: '',
          exercise_in_plan_id: '');
    }
  }

  bool isExerciseValid(ExerciseInPlan exerciseInPlan) {
    /// check if an exercise is valid.
    if (exerciseInPlan.reps < 0 ||
        exerciseInPlan.sets <= 0 ||
        exerciseInPlan.rest < 0 ||
        exerciseInPlan.weight < 0) return false;
    return true;
  }

  void clearSelections() {
    // clear all text controller's values.

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

    // fetch data
    Provider.of<ExerciseProvider>(context, listen: false)
        .fetchExercises()
        .then((_) => {
              exerciseOptions =
                  Provider.of<ExerciseProvider>(context, listen: false)
                      .exercises,
              Provider.of<ExerciseProvider>(context, listen: false)
                  .fetchExercises()
                  .then((value) => Provider.of<ExerciseInPlanProvider>(context,
                          listen: false)
                      .fetchData())
                  .then((_) => {
                        current_edited_plan =
                            Provider.of<PlanProvider>(context, listen: false)
                                .getCurrentEditedPlan(context),
                        setState(() => isInit = true)
                      }),
            });
  }

  @override
  Widget build(BuildContext context) {
    /// return visual representation of screen.
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
                    ElevatedButton(
                        onPressed: () => {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      PlanScreen(),
                                ),
                              )
                            },
                        child: Text(
                          'Close',
                          style: TextStyle(fontSize: 20),
                        )),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Exercise Name',
                        ),
                        controller: exerciseController,
                        onChanged: (value) {
                          setState(() {
                            exerciseOptions = Provider.of<ExerciseProvider>(
                                    context,
                                    listen: false)
                                .getExercisesWithSorting(
                                    name: value, active_muscles: []);
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Container(
                      height: 600.0,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: exerciseOptions.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            width: 200,
                            height: 300,
                            child: CardWidget(
                              exercise: exerciseOptions[index],
                              imageUrl: exerciseOptions[index].image_url,
                              key: Key(exerciseOptions[index].exercise_id),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
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
  Image imageFromExercise(
      Exercise exercise, double width, double height, BoxFit fit) {
    /// return image of exercise from network if image url is not empty
    if (exercise.image_url.isEmpty) {
      // return white square
      return Image.network(
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHFAD6nG4GX5NHYwDsmB8a_vwVY4DOxMqwPOiMVro&s');
    }

    // return the image from network.
    return Image.network(
      exercise.image_url,
      width: width,
      height: height,
      fit: fit,
    );
  }

  ExerciseInPlan getExerciseInPlanFromControllersWithValidityCheck(
      String exercise_id, String plan_id) {
    /// return exercise in plan from exercise id and plan id with a validity check.

    try {
      if (isExerciseValid(ExerciseInPlan(
              sets: int.parse(setsController.text),
              reps: int.parse(repsController.text),
              weight: double.parse(weightController.text),
              rest: int.parse(restController.text),
              exercise_id: exercise_id,
              plan_id: plan_id,
              exercise_in_plan_id: '')) ==
          false)
        return ExerciseInPlan(
            sets: -1,
            reps: -1,
            weight: -1,
            rest: -1,
            exercise_id: '',
            plan_id: '',
            exercise_in_plan_id: '');

      return ExerciseInPlan(
          sets: int.parse(setsController.text),
          reps: int.parse(repsController.text),
          weight: double.parse(weightController.text),
          rest: int.parse(restController.text),
          exercise_id: exercise_id,
          plan_id: plan_id,
          exercise_in_plan_id: '');
    } catch (e) {
      return ExerciseInPlan(
          sets: -1,
          reps: -1,
          weight: -1,
          rest: -1,
          exercise_id: '',
          plan_id: '',
          exercise_in_plan_id: '');
    }
  }

  bool isExerciseValid(ExerciseInPlan exerciseInPlan) {
    // check if an exercise is valid
    if (exerciseInPlan.sets <= 0 ||
        exerciseInPlan.reps < 0 || // 0 reps is until failure.
        exerciseInPlan.rest < 0 ||
        exerciseInPlan.weight < 0) return false;
    return true;
  }

  void clearSelections() {
    // clear all text controller's values.

    exerciseController.text = "";
    setsController.text = "";
    repsController.text = "";
    weightController.text = "";
    restController.text = "";
    selectedExercise = null;

    setState(() {});
  }

  String activeMusclesRepresentation() {
    /// return text as a list format of all active muscles in an exercise
    String result = '';
    for (String s in widget.exercise.active_muscles) {
      result += s + '\n';
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    // return visual representation of a single exercise.
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.5,
            child: imageFromExercise(widget.exercise, 200, 200, BoxFit.contain),
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
                  SizedBox(height: 5.0),
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
                      alignment: Alignment.center,
                      child: Container(
                        constraints: BoxConstraints(
                            minWidth: 200,
                            maxWidth: 260,
                            minHeight: 50,
                            maxHeight: 75),
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
                                  ExerciseInPlan exerciseInPlan =
                                      getExerciseInPlanFromControllersWithValidityCheck(
                                          widget.exercise.exercise_id,
                                          current_edited_plan!.id);

                                  if (exerciseInPlan.plan_id == '') {
                                    // values were invalid
                                    debugPrint('values were invalid!');
                                    return;
                                  }

                                  Provider.of<ExerciseInPlanProvider>(context,
                                          listen: false)
                                      .addData(exerciseInPlan)
                                      .then((_) => {
                                            current_edited_plan!
                                                .exercises_in_plan
                                                .add(Provider.of<
                                                            ExerciseInPlanProvider>(
                                                        context,
                                                        listen: false)
                                                    .ExercisesInPlanList
                                                    .last
                                                    .exercise_in_plan_id),
                                            Provider.of<PlanProvider>(context,
                                                    listen: false)
                                                .updateCurrentEditedPlan(
                                                    current_edited_plan!, true),
                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        PlanScreen(),
                                              ),
                                            )
                                          });
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
