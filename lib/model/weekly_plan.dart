import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_complete_guide/model/daily_plan.dart';

class WeeklyPlan {
  String name;

  User author;

  List<DailyPlan> daily_plans;

  String weekly_plan_id;

  WeeklyPlan({this.name, this.author, this.daily_plans, this.weekly_plan_id});
}
