import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/model/exercise_in_plan.dart';

import '../model/plan.dart';

class PlanInProgressProvider extends ChangeNotifier {
  Plan? plan = null;
  int index = 0;

  ExerciseInPlan? getNextExerciseInPlan() {
    index += 1;
    List<ExerciseInPlan> exercisesInPlan = plan!.exercises;

    if (exercisesInPlan.length == index) {
      // Done!

      return null;
    }

    return exercisesInPlan[index];
  }
}
