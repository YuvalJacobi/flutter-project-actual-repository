import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/model/exercise_in_plan.dart';

import '../model/plan.dart';

class PlanProvider extends ChangeNotifier {
  List<Plan> _plans = [];

  Plan? currently_played_plan = null;

  List<Plan> get getPlans {
    return [..._plans];
  }

  Plan? getCurrentEditedPlan() {
    return current_edited_plan;
  }

  Plan? current_edited_plan = null;

  Future<void> addData(Plan plan) async {
    if (getPlans.map((e) => e.id).contains(plan.id)) {
      await setData(plan);

      return;
    }

    await FirebaseFirestore.instance.collection('plans').add({
      'exercises_in_plan':
          plan.exercises.map((e) => exerciseInPlanToMap(e)).toList(),
      'name': plan.name,
      'user_id': plan.user_id
    }).then((doc) => {
          plan.id = doc.id,
          _plans.add(Plan(
              exercises: plan.exercises,
              name: plan.name,
              user_id: plan.user_id,
              id: doc.id))
        });

    notifyListeners();
  }

  Future<void> fetchPlans() async {
    await FirebaseFirestore.instance.collection("exercises").get().then(
      (querySnapshot) {
        print("Successfully fetched exercises!");
        for (var doc in querySnapshot.docs) {
          _plans.add(Plan(
              name: doc['name'],
              exercises: (doc['exercises'] as List<dynamic>).cast(),
              user_id: doc['user_id'],
              id: doc.id));
        }
        debugPrint("Successfully added exercises to list!");
      },
      onError: (e) => debugPrint("Error completing: $e"),
    );

    notifyListeners();
  }

  Map<String, dynamic> exerciseInPlanToMap(ExerciseInPlan exerciseInPlan) {
    return {
      'exercise_id': exerciseInPlan.exercise_id,
      'plan_id': exerciseInPlan.plan_id,
      'reps': exerciseInPlan.reps,
      'sets': exerciseInPlan.sets,
      'rest': exerciseInPlan.rest,
      'weight': exerciseInPlan.weight
    };
  }

  Future<void> setData(Plan plan) async {
    List<ExerciseInPlan> lst = plan.exercises;

    await FirebaseFirestore.instance
        .collection('plans')
        .doc(plan.id.isEmpty ? null : plan.id)
        .set({
      'exercises_in_plan': lst.map((e) => exerciseInPlanToMap(e)).toList(),
      'name': plan.name,
      'user_id': plan.user_id
    });
    _plans.add(plan);

    notifyListeners();
  }

  Plan getPlanFromExerciseInPlan(ExerciseInPlan exerciseInPlan) {
    return getPlanById(exerciseInPlan.exercise_id);
  }

  Plan getPlanById(String planId) {
    return _plans.firstWhere((element) => element.id == planId);
  }

  Future<void> deletePlanInUser(Plan plan) async {
    _plans.removeWhere((element) => element.id == plan.id);

    // Remove plan from user's plans.
    await FirebaseFirestore.instance
        .collection('users')
        .doc(plan.user_id)
        .set({'plans': _plans});

    // Remove plan from plans.
    await FirebaseFirestore.instance.collection('plans').doc(plan.id).delete();

    notifyListeners();
  }
}
