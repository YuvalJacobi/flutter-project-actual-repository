import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/model/exercise_in_plan.dart';
import 'package:provider/provider.dart';

import '../model/plan.dart';
import 'exercise_in_plan_provider.dart';

class PlanInProgressProvider extends ChangeNotifier {
  Plan? plan = null;
  int index = 0;
  int set_index = 0;

  ExerciseInPlan? getNextExerciseInPlan(BuildContext context) {
    index += 1;
    List<ExerciseInPlan> exercisesInPlan = [];

    for (String exercise_in_plan_id in plan!.exercises_in_plan) {
      exercisesInPlan.add(
          Provider.of<ExerciseInPlanProvider>(context, listen: false)
              .getExerciseInPlanById(exercise_in_plan_id));
    }

    if (exercisesInPlan.length == index) {
      // Done!

      return null;
    }

    return exercisesInPlan[index];
  }
}
