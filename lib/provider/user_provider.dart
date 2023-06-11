import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_complete_guide/provider/plans_provider.dart';
import 'package:provider/provider.dart';

import '../model/exercise_in_plan.dart';
import '../model/plan.dart';
import '../model/user_profile.dart';

class UserProvider extends ChangeNotifier {
  UserProfile myUser = new UserProfile(plans: []);

  final _auth = FirebaseAuth.instance;

  List<Plan> get my_plans {
    return [...myUser.plans];
  }

  Plan getPlanById(String id) {
    /// get plan of user by the plan's id, if it doesnt exist then return an empty plan.
    if (my_plans.map((e) => e.id).contains(id)) {
      return my_plans.firstWhere((element) => element.id == id);
    }
    return Plan(exercises_in_plan: [], name: '', user_id: '', id: '');
  }

  String getUserId() {
    // return the user's id.
    return myUser.user_id;
  }

  void addPlan(Plan p) {
    /// add plan to the list of plan's of user
    myUser.plans.add(p);
  }

  Map<String, dynamic> exerciseInPlanToMap(ExerciseInPlan exerciseInPlan) {
    /// convert ExerciseInPlan object to map representation.
    return {
      'exercise_id': exerciseInPlan.exercise_id,
      'plan_id': exerciseInPlan.plan_id,
      'reps': exerciseInPlan.reps,
      'sets': exerciseInPlan.sets,
      'rest': exerciseInPlan.rest,
      'weight': exerciseInPlan.weight
    };
  }

  Future<void> setData() async {
    /// set data of user to database.
    await FirebaseFirestore.instance
        .collection('users')
        .doc(myUser.user_id)
        .set({
      'first_name': myUser.first_name,
      'last_name': myUser.last_name,
      'email': myUser.email,
      'age': myUser.age,
      'height': myUser.height,
      'weight': myUser.weight,
      'username': myUser.username,
      'plans': myUser.plans.map((e) => e.id).toList(),
    });

    print('Successfully updated user!');

    notifyListeners();
  }

  void updatePlanOfUser(Plan plan) {
    /// update data of plan of user
    if (myUser.plans.map((e) => e.id).contains(plan.id)) {
      int ind = myUser.plans.map((e) => e.id).toList().indexOf(plan.id);
      myUser.plans[ind] = plan;
    } else {
      myUser.plans.add(plan);
    }

    setData();
  }

  List<Plan> dynamicOfPlansToPlansList(dynamic d, BuildContext context) {
    /// dynamic value retrieved from Firebase to list of plans.
    List<Plan> plans = [];
    for (String item in d) {
      String plan_id = item;

      Plan p = Provider.of<PlanProvider>(context, listen: false)
          .getPlanById(plan_id);

      if (p.id == '') continue;
      plans.add(p);
    }
    return plans;
  }

  Future<void> fetchUserData(BuildContext context) async {
    /// fetch user data from database
    await FirebaseFirestore.instance
        .collection('users')
        .doc(myUser.user_id)
        .get()
        .then((doc) => {
              myUser.first_name = doc['first_name'] ?? '',
              myUser.last_name = doc['last_name'] ?? '',
              myUser.email = doc['email'] ?? '',
              myUser.age = doc['age'] ?? '',
              myUser.height =
                  doc['height'] == null ? -1 : doc['height'] as double,
              myUser.weight =
                  doc['weight'] == null ? -1 : doc['weight'] as double,
              myUser.username = doc['username'] ?? '',
              myUser.plans = doc['plans'] == null
                  ? []
                  : dynamicOfPlansToPlansList(doc['plans'] ?? '', context)
            });

    //debugUser(myUser);
    notifyListeners();
  }

  void submitAuthForm(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx,
  ) async {
    /// perform sign up / register operation with parameters.
    UserCredential authResult;
    debugPrint('is login: $isLogin');
    if (isLogin) {
      authResult = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } else {
      authResult = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint('authresult uid: ' + authResult.user!.uid);
      myUser.user_id = authResult.user!.uid;
      myUser.email = email;
      myUser.username = username;
      setData();
    }
  }
}
