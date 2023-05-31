import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/model/exercise.dart';
import 'package:flutter_complete_guide/model/exercise_in_plan.dart';
import 'package:flutter_complete_guide/provider/exercise_in_plan_provider.dart';
import 'package:flutter_complete_guide/provider/exercise_provider.dart';
import 'package:flutter_complete_guide/provider/plans_provider.dart';
import 'package:flutter_complete_guide/screens/home_screen.dart';
import 'package:flutter_complete_guide/screens/plans_screen.dart';

import 'package:provider/provider.dart';

import '../model/plan.dart';
import 'add_exercise_to_plan_screen.dart';

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

final TextEditingController setsController = TextEditingController();
final TextEditingController repsController = TextEditingController();
final TextEditingController weightController = TextEditingController();
final TextEditingController restController = TextEditingController();
Exercise? selectedExercise = null;
Plan? current_edited_plan = null;

class _EditPlanScreen extends State<EditPlanScreen> {
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
    if (exerciseInPlan.reps < 0 ||
        exerciseInPlan.sets <= 0 ||
        exerciseInPlan.rest < 0 ||
        exerciseInPlan.weight < 0) return false;
    return true;
  }

  void clearSelections() {
    setsController.text = "";
    repsController.text = "";
    weightController.text = "";
    restController.text = "";
    selectedExercise = null;

    setState(() {});
  }

  void addExercise() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => PlanEditorScreen(),
      ),
    );
  }

  List<Exercise> exercisesOfPlan(Plan p, BuildContext context) {
    List<Exercise> lst = [];
    for (String exerciseInPlanId in p.exercises_in_plan) {
      ExerciseInPlan exerciseInPlan =
          Provider.of<ExerciseInPlanProvider>(context, listen: false)
              .getExerciseInPlanById(exerciseInPlanId);
      Exercise exercise = Provider.of<ExerciseProvider>(context, listen: false)
          .getExercisesWithSorting(
              exercise_id: exerciseInPlan.exercise_id, active_muscles: [])[0];
      lst.add(exercise);
    }
    return lst;
  }

  @override
  void didChangeDependencies() async {
    Provider.of<PlanProvider>(context, listen: false).fetchPlans(context).then(
        (_) => Provider.of<ExerciseProvider>(context, listen: false)
            .fetchExercises()
            .then((value) =>
                Provider.of<ExerciseInPlanProvider>(context, listen: false)
                    .fetchData()
                    .then((value) => {
                          current_edited_plan =
                              Provider.of<PlanProvider>(context, listen: false)
                                  .getCurrentEditedPlan(context),
                          setState(() => {isInit = true})
                        })));

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Your Exercises'),
      ),
      body: isInit == false
          ? Center(child: CircularProgressIndicator())
          : Container(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.all(3.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 30),
                          Container(
                            alignment: Alignment.topLeft,
                            width: 120,
                            height: 50,
                            child: ElevatedButton(
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
                          ),
                          SizedBox(width: 110),
                          Container(
                            alignment: Alignment.topRight,
                            width: 100,
                            height: 50,
                            child: ElevatedButton(
                                onPressed: () => addExercise(),
                                child: Text(
                                  'Add exercise',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 15),
                                )),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: SingleChildScrollView(
                          child: ListView.builder(
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount:
                                current_edited_plan!.exercises_in_plan.length,
                            itemBuilder: (BuildContext context, int index) {
                              ExerciseInPlan exerciseInPlan =
                                  Provider.of<ExerciseInPlanProvider>(context,
                                          listen: false)
                                      .getExerciseInPlanById(
                                          current_edited_plan!
                                              .exercises_in_plan[index]);

                              Exercise exercise = Provider.of<ExerciseProvider>(
                                      context,
                                      listen: false)
                                  .getExercisesWithSorting(
                                      exercise_id: exerciseInPlan.exercise_id,
                                      active_muscles: [])[0];

                              return Container(
                                width: 250,
                                height: 250,
                                child: CardWidget(
                                  exerciseInPlan: exerciseInPlan,
                                  exercise: exercise,
                                  imageUrl: exercise.image_url,
                                  key: Key(exerciseInPlan.exercise_in_plan_id),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class CardWidget extends StatefulWidget {
  final Exercise exercise;
  final String imageUrl;
  final ExerciseInPlan exerciseInPlan;

  const CardWidget(
      {required Key key,
      required this.exerciseInPlan,
      required this.exercise,
      required this.imageUrl})
      : super(key: key);

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  Image imageFromExercise(
      Exercise exercise, double width, double height, BoxFit fit) {
    if (exercise.image_url.isEmpty) {
      // return white square
      return Image.network(
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHFAD6nG4GX5NHYwDsmB8a_vwVY4DOxMqwPOiMVro&s');
    }
    return Image.network(
      exercise.image_url,
      width: width,
      height: height,
      fit: fit,
    );
  }

  ExerciseInPlan getExerciseInPlanFromControllersWithValidityCheck(
      String exercise_id, String plan_id, String exercise_in_plan_id) {
    try {
      if (isExerciseValid(ExerciseInPlan(
              sets: int.parse(setsController.text),
              reps: int.parse(repsController.text),
              weight: double.parse(weightController.text),
              rest: int.parse(restController.text),
              exercise_id: exercise_id,
              plan_id: plan_id,
              exercise_in_plan_id: exercise_in_plan_id)) ==
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
          exercise_in_plan_id: exercise_in_plan_id);
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
    if (exerciseInPlan.reps < 0 ||
        exerciseInPlan.sets <= 0 ||
        exerciseInPlan.rest < 0 ||
        exerciseInPlan.weight < 0) return false;
    return true;
  }

  void clearSelections() {
    setsController.text = "";
    repsController.text = "";
    weightController.text = "";
    restController.text = "";
    selectedExercise = null;

    setState(() {});
  }

  void setSelectionsByExerciseInPlan(ExerciseInPlan exerciseInPlan) {
    setsController.text = exerciseInPlan.sets.toString();
    repsController.text = exerciseInPlan.reps.toString();
    weightController.text = exerciseInPlan.weight.toString();
    restController.text = exerciseInPlan.rest.toString();
    selectedExercise = null;

    setState(() {});
  }

  String activeMusclesRepresentation() {
    String result = '';
    for (String s in widget.exercise.active_muscles) {
      result += s + '\n';
    }
    return result;
  }

  void updateCurrentEditedPlan(String exerciseInPlanId) {
    if (current_edited_plan!.exercises_in_plan.contains(exerciseInPlanId)) {
      int index = current_edited_plan!.exercises_in_plan
          .toList()
          .indexOf(exerciseInPlanId);
      current_edited_plan!.exercises_in_plan[index] = exerciseInPlanId;
    } else {
      current_edited_plan!.exercises_in_plan.add(exerciseInPlanId);
    }
  }

  @override
  Widget build(BuildContext context) {
    current_edited_plan = Provider.of<PlanProvider>(context, listen: false)
        .getCurrentEditedPlan(context);

    return Card(
      child: Row(
        children: [
          Container(
            alignment: Alignment.topLeft,
            width: MediaQuery.of(context).size.width * 0.43,
            height: MediaQuery.of(context).size.height * 0.5,
            child: imageFromExercise(
                widget.exercise,
                MediaQuery.of(context).size.width * 0.6,
                MediaQuery.of(context).size.height * 0.6,
                BoxFit.contain),
          ),
          SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.exercise.name,
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Active Muscles',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 15.0,
                      color: Colors.white),
                ),
                SizedBox(height: 8.0),
                Text(
                  activeMusclesRepresentation(),
                  style: TextStyle(fontSize: 12.0, color: Colors.white),
                ),
                SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        // constraints: BoxConstraints(
                        //     minWidth: 200,
                        //     maxWidth: 250,
                        //     minHeight: 20,
                        //     maxHeight: 55),
                        alignment: Alignment.bottomLeft,
                        child: PopupMenuButton(
                          onOpened: () {
                            setSelectionsByExerciseInPlan(
                                widget.exerciseInPlan);
                          },
                          onCanceled: () {},
                          onSelected: (value) {},
                          child: Container(
                              alignment: Alignment.bottomCenter,
                              decoration: BoxDecoration(
                                  color: Colors.indigo,
                                  borderRadius: BorderRadius.circular(4)),
                              child: Text('Edit',
                                  style: TextStyle(
                                      fontSize: 30,
                                      backgroundColor: Colors.indigo))),
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
                                  ExerciseInPlan _exerciseInPlan =
                                      getExerciseInPlanFromControllersWithValidityCheck(
                                          widget.exercise.exercise_id,
                                          current_edited_plan!.id,
                                          widget.exerciseInPlan
                                              .exercise_in_plan_id);

                                  if (_exerciseInPlan.plan_id == '') {
                                    // values were invalid
                                    debugPrint('values were invalid!');
                                    return;
                                  }

                                  Provider.of<ExerciseInPlanProvider>(context,
                                          listen: false)
                                      .updateData(_exerciseInPlan)
                                      .then((_) => {
                                            updateCurrentEditedPlan(
                                                _exerciseInPlan
                                                    .exercise_in_plan_id),
                                            Provider.of<PlanProvider>(context,
                                                    listen: false)
                                                .updateCurrentEditedPlan(
                                                    current_edited_plan!),
                                            Provider.of<PlanProvider>(context,
                                                    listen: false)
                                                .addData(current_edited_plan!,
                                                    context)
                                                .then((_) =>
                                                    Navigator.of(context).pop())
                                          });
                                },
                              ))
                            ];
                          },
                        ),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
