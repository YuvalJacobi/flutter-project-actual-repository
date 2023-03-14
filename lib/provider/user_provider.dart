import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../model/user.dart';

class UserProvider extends ChangeNotifier {
  List<User> _users;

  List<User> get users {
    return [..._users];
  }

  User getUserById(String user_id) {
    return _users.firstWhere((element) => element.user_id == user_id);
  }

  UserProvider();

  Future<void> setData(WeeklyPlan weekly_plan) {
    FirebaseFirestore.instance
        .collection('weekly_plans')
        .doc(weekly_plan.weekly_plan_id)
        .set({
      'name': weekly_plan.name,
      'author_id': weekly_plan.author_id,
      'daily_plans': weekly_plan.daily_plans,
      'id': weekly_plan.weekly_plan_id,
    });
  }

  Future<void> fetchData() {
    FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        _users.add(User({
          doc['first_name'],
          doc['last_name'],
          doc['email'],
          doc['age'],
          doc['height'],
          doc['weight'],
          doc['following'],
          doc['followers'],
          doc['weekly_plans'],
          doc['daily_plans'],
          doc.id
        }));
      });
    });
  }
}
