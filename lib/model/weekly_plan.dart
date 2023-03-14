import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_complete_guide/model/daily_plan.dart';

class WeeklyPlan {
  String name;

  String author_id;

  Map<String, DailyPlan> daily_plans;

  String weekly_plan_id;

  WeeklyPlan(Set set,
      {this.name, this.author_id, this.daily_plans, this.weekly_plan_id});
}
