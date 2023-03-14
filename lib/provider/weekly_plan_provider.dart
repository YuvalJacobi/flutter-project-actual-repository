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

  Future<void> setData(WeeklyPlan weekly_plan) {
    FirebaseFirestore.instance
        .collection('weekly_plans')
        .doc(weekly_plan.weekly_plan_id)
        .set({
      'name': weekly_plan.name,
      'author_id': weekly_plan.author_id,
      'daily_plans': weekly_plan.daily_plans,
    });
  }

  Future<void> addData(WeeklyPlan weekly_plan) {
    FirebaseFirestore.instance.collection('weekly_plans').add({
      'name': weekly_plan.name,
      'author_id': weekly_plan.author_id,
      'daily_plans': weekly_plan.daily_plans,
    }).then((DocumentReference docref) {
      weekly_plan.weekly_plan_id = docref.id;
    });
  }

  Future<void> fetchData() {
    FirebaseFirestore.instance
        .collection('weekly_plans')
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
