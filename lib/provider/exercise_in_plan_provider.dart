import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/model/exercise_in_plan.dart';
import 'package:flutter_complete_guide/provider/user_provider.dart';
import 'package:provider/provider.dart';

import '../model/exercise.dart';
import '../model/plan.dart';

class ExerciseInPlanProvider extends ChangeNotifier {
  Future<void> addData(ExerciseInPlan exerciseInPlan) async {
    await FirebaseFirestore.instance.collection('exercises_in_plan').add({
      'sets': exerciseInPlan.sets,
      'reps': exerciseInPlan.reps,
      'weight': exerciseInPlan.weight,
      'rest': exerciseInPlan.rest,
      'exercise_id': exerciseInPlan.exercise_id,
      'plan_id': exerciseInPlan.plan_id
    });
  }

  bool Validate(
      Exercise exercise, String uid, String plan_id, BuildContext context) {
    List<Plan> plans =
        Provider.of<UserProvider>(context, listen: false).myUser.plans;

    Plan plan = plans.firstWhere((element) => element.id == plan_id);

    ExerciseInPlan exerciseInPlan = plan.exercises
        .firstWhere((element) => element.exercise_id == exercise.exercise_id);

    return true;
  }
}
