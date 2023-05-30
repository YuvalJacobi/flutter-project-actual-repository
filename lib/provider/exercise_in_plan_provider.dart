import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/model/exercise_in_plan.dart';
import 'package:flutter_complete_guide/provider/user_provider.dart';
import 'package:provider/provider.dart';

import '../model/exercise.dart';
import '../model/plan.dart';

class ExerciseInPlanProvider extends ChangeNotifier {
  List<ExerciseInPlan> _exercisesInPlan = [];

  List<ExerciseInPlan> get ExercisesInPlanList {
    return _exercisesInPlan;
  }

  void addExerciseInPlanToList(ExerciseInPlan exerciseInPlan) {
    if (_exercisesInPlan
        .map((e) => e.exercise_in_plan_id)
        .contains(exerciseInPlan.exercise_in_plan_id)) {
      int index = _exercisesInPlan
          .map((e) => e.exercise_in_plan_id)
          .toList()
          .indexOf(exerciseInPlan.exercise_in_plan_id);
      _exercisesInPlan[index] = exerciseInPlan;
      return;
    }
    _exercisesInPlan.add(exerciseInPlan);
  }

  Future<void> fetchData() async {
    await FirebaseFirestore.instance.collection('exercises_in_plan').get().then(
      (querySnapshot) {
        print("Successfully fetched exercises!");
        for (var doc in querySnapshot.docs) {
          addExerciseInPlanToList(ExerciseInPlan(
              sets: doc['sets'] ?? -1,
              weight: doc['weight'] == null
                  ? -1
                  : (doc['weight'] as num).toDouble(),
              rest: doc['rest'] ?? -1,
              reps: doc['reps'] ?? -1,
              plan_id: doc['plan_id'] ?? '',
              exercise_id: doc['exercise_id'] ?? '',
              exercise_in_plan_id: doc.id));
        }
        debugPrint("Successfully added exercises to list!");
      },
      onError: (e) => debugPrint("Error completing: $e"),
    );
  }

  Future<void> addData(ExerciseInPlan exerciseInPlan) async {
    await FirebaseFirestore.instance.collection('exercises_in_plan').add({
      'sets': exerciseInPlan.sets,
      'reps': exerciseInPlan.reps,
      'weight': exerciseInPlan.weight,
      'rest': exerciseInPlan.rest,
      'exercise_id': exerciseInPlan.exercise_id,
      'plan_id': exerciseInPlan.plan_id
    }).then((doc) => {
          exerciseInPlan.exercise_in_plan_id = doc.id,
          addExerciseInPlanToList(exerciseInPlan)
        });
  }

  List<ExerciseInPlan> exercisesInPlanByIds(List<String> ids) {
    List<ExerciseInPlan> lst = [];
    for (String exercise_in_plan_id in ids) {
      lst.add(getExerciseInPlanById(exercise_in_plan_id));
    }
    return lst;
  }

  Future<void> updateData(ExerciseInPlan exerciseInPlan) async {
    await FirebaseFirestore.instance
        .collection('exercises_in_plan')
        .doc(exerciseInPlan.exercise_in_plan_id)
        .set({
      'sets': exerciseInPlan.sets,
      'reps': exerciseInPlan.reps,
      'weight': exerciseInPlan.weight,
      'rest': exerciseInPlan.rest,
      'exercise_id': exerciseInPlan.exercise_id,
      'plan_id': exerciseInPlan.plan_id
    }).then((_) => {addExerciseInPlanToList(exerciseInPlan)});
  }

  ExerciseInPlan getExerciseInPlanById(String id) {
    if (_exercisesInPlan.isEmpty)
      return ExerciseInPlan(
          sets: 0,
          reps: 0,
          weight: 0,
          rest: 0,
          exercise_id: '',
          plan_id: '',
          exercise_in_plan_id: '');

    return _exercisesInPlan
        .firstWhere((element) => element.exercise_in_plan_id == id);
  }

  bool Validate(
      Exercise exercise, String uid, String plan_id, BuildContext context) {
    List<Plan> plans =
        Provider.of<UserProvider>(context, listen: false).myUser.plans;

    Plan plan = plans.firstWhere((element) => element.id == plan_id);

    return true;
  }
}
