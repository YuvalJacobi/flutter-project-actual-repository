import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/model/exercise_in_plan.dart';

class ExerciseInPlanProvider extends ChangeNotifier {
  ExerciseInPlan current_edited_exercise_in_plan = ExerciseInPlan(
      sets: -1,
      reps: -1,
      weight: -1,
      rest: -1,
      exercise_id: '-1',
      plan_id: '-1');

  ExerciseInPlan? current_played_exercise_in_plan = null;

  void Empty() {
    current_edited_exercise_in_plan = ExerciseInPlan(
        sets: -1,
        reps: -1,
        weight: -1,
        rest: -1,
        exercise_id: '-1',
        plan_id: '-1');
  }

  bool isExerciseValid(ExerciseInPlan exerciseInPlan) {
    if (exerciseInPlan.reps <= 0 ||
        exerciseInPlan.sets <= 0 ||
        exerciseInPlan.rest < 0 ||
        exerciseInPlan.weight < 0) return false;
    return true;
  }

  bool isExerciseConnectedToPlan(ExerciseInPlan exerciseInPlan) {
    if (exerciseInPlan.exercise_id == '-1' || exerciseInPlan.plan_id == '-1')
      return false;
    return true;
  }

  bool isExerciseInPlanEmpty(ExerciseInPlan exerciseInPlan) {
    if (isExerciseValid(exerciseInPlan) == false) return false;

    if (isExerciseConnectedToPlan(exerciseInPlan) == false) return false;

    return true;
  }

  bool isEditingExerciseInPlan() =>
      isExerciseInPlanEmpty(current_edited_exercise_in_plan);
}
