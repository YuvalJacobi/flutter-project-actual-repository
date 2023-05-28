import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../model/exercise_in_plan.dart';
import '../model/plan.dart';
import '../model/user_profile.dart';

class UserProvider extends ChangeNotifier {
  UserProfile myUser = new UserProfile(plans: []);

  final _auth = FirebaseAuth.instance;

  String getUserId() {
    return myUser.user_id;
  }

  void debugUser(UserProfile user) {
    int ind = 1;
    for (Plan p in user.plans) {
      debugPrint(ind.toString() +
          '#: ' +
          p.name +
          ' ' +
          p.exercises.length.toString());
      ind++;
    }
  }

  Map<String, dynamic> exerciseInPlanToMap(ExerciseInPlan exerciseInPlan) {
    return {
      'exercise_id': exerciseInPlan.exercise_id,
      'plan_id': exerciseInPlan.plan_id,
      'reps': exerciseInPlan.reps,
      'sets': exerciseInPlan.sets,
      'rest': exerciseInPlan.rest,
      'weight': exerciseInPlan.weight
    };
  }

  Map<String, dynamic> planToMap(Plan plan) {
    return {
      'name': plan.name,
      'user_id': plan.user_id,
      'exercises_in_plan':
          plan.exercises.map((e) => exerciseInPlanToMap(e)).toList()
    };
  }

  Future<void> setData() async {
    debugPrint(myUser.toString());

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
      'plans': myUser.plans.map((e) => planToMap(e)).toList(),
    });

    print('Successfully updated user!');

    notifyListeners();
  }

  void updatePlanOfUser(Plan plan) {
    if (myUser.plans.map((e) => e.id).contains(plan.id)) {
      int ind = myUser.plans.map((e) => e.id).toList().indexOf(plan.id);
      myUser.plans[ind] = plan;
    } else {
      myUser.plans.add(plan);
    }

    setData();
  }

  List<ExerciseInPlan> dynamicOfExercisesInPlanToExercisesInPlan(dynamic d) {
    List<ExerciseInPlan> eip = [];
    for (Map<String, dynamic> item in d) {
      eip.add(ExerciseInPlan(
          sets: item['sets'] ?? -1,
          reps: item['reps'] ?? -1,
          weight: item['weight'] ?? -1,
          rest: item['rest'] ?? -1,
          exercise_id: item['exercise_id'] ?? '',
          plan_id: item['plan_id'] ?? ''));
    }
    return eip;
  }

  List<Plan> dynamicOfPlansToPlansList(dynamic d) {
    List<Plan> plans = [];
    for (Map<String, dynamic> item in d) {
      plans.add(Plan(
          exercises: dynamicOfExercisesInPlanToExercisesInPlan(
              item['exercises_in_plan'] ?? ''),
          name: item['name'] ?? '',
          user_id: item['user_id'] ?? '',
          id: item['plan_id'] ?? ''));
    }
    return plans;
  }

  Future<void> fetchUserData() async {
    debugPrint(getUserId());
    await FirebaseFirestore.instance
        .collection('users')
        .doc(myUser.user_id)
        .get()
        .then((doc) => {
              myUser.first_name = doc['first_name'] ?? '',
              myUser.last_name = doc['last_name'] ?? '',
              myUser.email = doc['email'] ?? '',
              myUser.age = doc['age'] ?? '',
              myUser.height = doc['height'] ?? -1,
              myUser.weight = doc['weight'] ?? -1,
              myUser.username = doc['username'] ?? '',
              myUser.plans = doc['plans'] == null
                  ? []
                  : dynamicOfPlansToPlansList(doc['plans'] ?? '')
            });

    debugUser(myUser);
    notifyListeners();
  }

  void submitAuthForm(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx,
  ) async {
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

    notifyListeners();
  }

  // Future<void> addData(User user) async {
  //   FirebaseFirestore.instance.collection('users').add({
  //     'first_name': user.first_name,
  //     'last_name': user.last_name,
  //     'email': user.email,
  //     'age': user.age,
  //     'height': user.height,
  //     'weight': user.weight,
  //     'username': user.username,
  //   }).then((DocumentReference docref) {
  //     user.user_id = docref.id;
  //   });
  // }

  // Future<void> fetchData() async {
  //   FirebaseFirestore.instance
  //       .collection('users')
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     querySnapshot.docs.forEach((doc) {
  //       _users.add(User(doc['first_name'], doc['last_name'], doc['email'],
  //           doc['age'], doc['height'], doc['weight'], doc['username'], doc.id));
  //     });
  //   });
  // }

  // bool isValidEmail(String email_address) {
  //   return RegExp(
  //           r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
  //       .hasMatch(email_address);
  // }

  // bool isValidUser(User user) {
  //   if (user.first_name.isEmpty || user.first_name == "") return false;

  //   if (user.last_name.isEmpty || user.last_name == "") return false;

  //   if (user.username.isEmpty || user.username == "") return false;

  //   if (user.age <= 0) return false;

  //   if (user.height <= 0) return false;

  //   if (user.weight <= 0) return false;

  //   if (isValidEmail(user.email) == false) return false;

  //   return true;
  // }

  // String stringify(User user) {
  //   if (isValidUser(user) == false) return '';

  //   String t = '';

  //   t += 'First name: ${user.first_name}\n';

  //   t += 'Last name: ${user.last_name}\n';

  //   t += 'Username: ${user.username}';

  //   t += 'Age: ${user.age}\n';

  //   t += 'Height: ${user.height}\n';

  //   t += 'Weight: ${user.weight}\n';

  //   return t;
  // }
}
