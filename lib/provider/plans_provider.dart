import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/model/exercise_in_plan.dart';

import '../model/plan.dart';

class PlanProvider extends ChangeNotifier {
  List<Plan> _plans = [];

  List<Plan> get getPlans {
    return [..._plans];
  }

  Plan? getCurrentEditedPlan() {
    return current_edited_plan;
  }

  Plan? current_edited_plan = null;

  Future<void> setData(Plan plan) async {
    await FirebaseFirestore.instance.collection('users').doc(plan.id).set({
      'exercises': plan.exercises,
      'name': plan.name,
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
    FirebaseFirestore.instance
        .collection('users')
        .doc(plan.user_id)
        .set({'plans': _plans});

    // Remove plan from plans.
    FirebaseFirestore.instance.collection('plans').doc(plan.id).delete();

    notifyListeners();
  }
}
