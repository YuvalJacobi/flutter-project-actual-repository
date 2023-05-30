class ExerciseInPlan {
  int sets;

  int reps;

  double weight; // in kg

  int rest; // in seconds

  String exercise_id;

  String plan_id;

  String exercise_in_plan_id;

  ExerciseInPlan(
      {required this.sets,
      required this.reps,
      required this.weight,
      required this.rest,
      required this.exercise_id,
      required this.plan_id,
      required this.exercise_in_plan_id});
}
