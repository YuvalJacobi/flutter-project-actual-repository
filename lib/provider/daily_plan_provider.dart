import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_complete_guide/model/daily_plan.dart';

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

  Future<void> setData(DailyPlan daily_plan) {
    FirebaseFirestore.instance
        .collection('daily_plans')
        .doc(daily_plan.daily_plan_id)
        .set({
      'author_id': daily_plan.author_id,
      'day': daily_plan.day,
      'dishes': daily_plan.dishes,
      'name': daily_plan.name,
    });
  }

  Future<void> addData(DailyPlan daily_plan) {
    FirebaseFirestore.instance.collection('daily_plans').add({
      'author_id': daily_plan.author_id,
      'day': daily_plan.day,
      'dishes': daily_plan.dishes,
      'name': daily_plan.name,
    }).then((DocumentReference docref) {
      daily_plan.daily_plan_id = docref.id;
    });
  }

  Future<void> fetchData() {
    FirebaseFirestore.instance
        .collection('daily_plans')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        _daily_plans.add(DailyPlan({
          doc['name'],
          doc['day'],
          doc['author_id'],
          doc['dishes'],
          doc.id,
        }));
      });
    });
  }

  String stringify(DailyPlan dailyPlan) {
    String t = '';

    t += 'Name: ${dailyPlan.name}\n';

    t += 'Name: ${dailyPlan.day}\n';

    t += 'Name: ${dailyPlan.author_id}\n';

    t += 'Name: ${dailyPlan.dishes}';

    return t;
  }
}
