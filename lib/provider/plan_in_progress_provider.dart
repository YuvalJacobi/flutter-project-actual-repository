import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/model/exercise_in_plan.dart';
import 'package:provider/provider.dart';

import '../model/plan.dart';
import 'exercise_in_plan_provider.dart';

class PlanInProgressProvider extends ChangeNotifier {
  /// current plan in progress
  Plan? plan = null;

  /// index of current exercise being done
  int index = 0;

  /// index of current set being done.
  int set_index = 0;

  DateTime start = DateTime(-999);

  DateTime end = DateTime(-999);

  ExerciseInPlan? getNextExerciseInPlan(BuildContext context) {
    /// increment index of current exercise by 1
    index += 1;

    // list of all exercises in plan.
    List<ExerciseInPlan> exercisesInPlan = [];

    /// add all exercises in plan to the list.
    for (String exercise_in_plan_id in plan!.exercises_in_plan) {
      exercisesInPlan.add(
          Provider.of<ExerciseInPlanProvider>(context, listen: false)
              .getExerciseInPlanById(exercise_in_plan_id));
    }

    if (exercisesInPlan.length == index) {
      /// last exercise is over, return null

      return null;
    }

    // return next exercise to be done.
    return exercisesInPlan[index];
  }

  void Clear() {
    plan = null;
    index = 0;
    set_index = 0;
    end = DateTime(-999);
  }
}
