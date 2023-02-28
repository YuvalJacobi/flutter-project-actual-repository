import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_complete_guide/model/dish.dart';

import '../model/user.dart';
import '../model/weekly_plan.dart';

class WeeklyPlanProvider extends ChangeNotifier {
  List<WeeklyPlan> _weekly_plans;

  List<WeeklyPlan> get weekly_plans {
    return [..._weekly_plans];
  }

  WeeklyPlan getWeeklyPlanById(String weekly_plan_id) {
    return _weekly_plans
        .firstWhere((element) => element.weekly_plan_id == weekly_plan_id);
  }

  List<WeeklyPlan> getWeeklyPlansByUserId(String user_id) {
    return weekly_plans.where((element) => element.author_id == user_id);
  }

  WeeklyPlanProvider();
}
