import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/main.dart';
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

  Future<void> addData(Plan plan) async {
    if (getPlans.map((e) => e.id).contains(plan.id)) {
      await setData(plan);

      return;
    }

    FirebaseFirestore.instance
        .collection('plans')
        .add({'exercises_in_plan': plan.exercises, 'name': plan.name}).then(
            (doc) => plan.id = doc.id);

    _plans.add(plan);
  }

  Future<void> setData(Plan plan) async {
    List<ExerciseInPlan> lst = plan.exercises;

    await FirebaseFirestore.instance
        .collection('plans')
        .doc(plan.id.isEmpty ? null : plan.id)
        .set({
      'exercises_in_plan': lst,
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
