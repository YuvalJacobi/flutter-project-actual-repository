import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_complete_guide/model/daily_plan.dart';
import 'package:flutter_complete_guide/model/dish.dart';

import '../model/user.dart';
import '../model/weekly_plan.dart';

class DailyPlanProvider extends ChangeNotifier {
  List<DailyPlan> _daily_plans;

  List<DailyPlan> get daily_plans {
    return [..._daily_plans];
  }

  DailyPlan getDailyPlanById(String daily_plan_id) {
    return _daily_plans
        .firstWhere((element) => element.daily_plan_id == daily_plan_id);
  }

  List<DailyPlan> getDailyPlansByUserId(String user_id) {
    return daily_plans.where((element) => element.author_id == user_id);
  }

  DailyPlanProvider();
}
