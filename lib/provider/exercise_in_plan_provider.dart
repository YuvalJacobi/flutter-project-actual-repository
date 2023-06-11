import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/model/exercise_in_plan.dart';
import 'package:flutter_complete_guide/provider/plans_provider.dart';
import 'package:flutter_complete_guide/provider/user_provider.dart';
import 'package:provider/provider.dart';

import '../model/plan.dart';

class ExerciseInPlanProvider extends ChangeNotifier {
  /// list of exercises in plan
  List<ExerciseInPlan> _exercisesInPlan = [];

  List<ExerciseInPlan> get ExercisesInPlanList {
    /// retrieve list of exercises in plan.
    return _exercisesInPlan;
  }

  /// remove exercise in plan from list and user.
  void removeExerciseInPlan(
      ExerciseInPlan exerciseInPlan, BuildContext context) {
    /// check if exercise in plan actually exists locally.
    if (_exercisesInPlan.contains(exerciseInPlan)) {
      _exercisesInPlan.remove(exerciseInPlan);
    }

    /// check if exercise in plan exists in the plan currenly being edited.
    if (Provider.of<PlanProvider>(context, listen: false)
        .getCurrentEditedPlan(context)
        .exercises_in_plan
        .contains(exerciseInPlan.exercise_in_plan_id)) {
      Provider.of<PlanProvider>(context, listen: false)
          .getCurrentEditedPlan(context)
          .exercises_in_plan
          .remove(exerciseInPlan.exercise_in_plan_id);

      Provider.of<UserProvider>(context, listen: false).updatePlanOfUser(
          Provider.of<PlanProvider>(context, listen: false)
              .getCurrentEditedPlan(context));
    }
  }

  /// add exercise in plan to the local list.
  void addExerciseInPlanToList(ExerciseInPlan exerciseInPlan) {
    /// check if the exercise in plan exists in the list.
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
    /// fetch exercises in plan from database.
    await FirebaseFirestore.instance.collection('exercises_in_plan').get().then(
      (querySnapshot) {
        print("Successfully fetched exercises!");
        for (var doc in querySnapshot.docs) {
          if (doc['plan_id'] == null || doc['plan_id'] == '') continue;

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
    /// add exercise in plan to database.
    await FirebaseFirestore.instance.collection('exercises_in_plan').add({
      'sets': exerciseInPlan.sets,
      'reps': exerciseInPlan.reps,
      'weight': exerciseInPlan.weight,
      'rest': exerciseInPlan.rest,
      'exercise_id': exerciseInPlan.exercise_id,
      'plan_id': exerciseInPlan.plan_id
    }).then((doc) => {
          exerciseInPlan.exercise_in_plan_id = doc.id,

          /// add that exercise to local list.
          addExerciseInPlanToList(exerciseInPlan)
        });
  }

  Future<void> removeData(
      Plan plan, ExerciseInPlan exerciseInPlan, BuildContext context) async {
    /// remove exercise in plan locally and globally.
    removeExerciseInPlan(exerciseInPlan, context);
    await FirebaseFirestore.instance
        .collection('exercises_in_plan')
        .doc(exerciseInPlan.exercise_in_plan_id)
        .delete();

    /// this list will have all elements from before excluding the removed exercise in plan object.
    List<String> lst = plan.exercises_in_plan
        .where((element) => element != exerciseInPlan.exercise_in_plan_id)
        .toList();

    /// update in firebase.
    await FirebaseFirestore.instance
        .collection('plans')
        .doc(exerciseInPlan.plan_id)
        .update({'exercises_in_plan': lst});
  }

  List<ExerciseInPlan> exercisesInPlanByIds(List<String> ids) {
    /// get exercises in plan by their respective ids
    List<ExerciseInPlan> lst = [];
    for (String exercise_in_plan_id in ids) {
      lst.add(getExerciseInPlanById(exercise_in_plan_id));
    }
    return lst;
  }

  Future<void> updateData(ExerciseInPlan exerciseInPlan) async {
    /// update data of specific exercise in plan in database.
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
    /// get exercise in plan by its id.
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
}
