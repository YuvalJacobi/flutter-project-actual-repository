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

  Future<void> fetchData() {
    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        _weekly_plans.add(WeeklyPlan({
          doc['name'],
          doc['author_id'],
          doc['daily_plans'],
          doc.id,
        }));
      });
    });
  }
}
