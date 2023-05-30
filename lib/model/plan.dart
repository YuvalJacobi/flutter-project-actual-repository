import 'package:flutter_complete_guide/model/exercise_in_plan.dart';

class Plan {
  List<String> exercises_in_plan;

  String name;

  String user_id;

  String id;

  Plan(
      {required this.exercises_in_plan,
      required this.name,
      required this.user_id,
      required this.id});
}
