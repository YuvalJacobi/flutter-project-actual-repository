import 'package:flutter_complete_guide/model/daily_plan.dart';
import 'package:flutter_complete_guide/model/weekly_plan.dart';

class User {
  String first_name;

  String last_name;

  String username;

  String email;

  int age;

  double height;

  double weight;

  List<String> following;

  List<String> followers;

  Map<String, WeeklyPlan> weekly_plans;

  Map<String, DailyPlan> daily_plans;

  String user_id;

  User(
      this.first_name,
      this.last_name,
      this.username,
      this.email,
      this.age,
      this.height,
      this.weight,
      this.following,
      this.followers,
      this.weekly_plans,
      this.daily_plans,
      this.user_id);
}
