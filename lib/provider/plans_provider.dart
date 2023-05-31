import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/model/exercise_in_plan.dart';
import 'package:flutter_complete_guide/model/user_profile.dart';
import 'package:flutter_complete_guide/provider/exercise_in_plan_provider.dart';
import 'package:flutter_complete_guide/provider/user_provider.dart';
import 'package:provider/provider.dart';

import '../model/plan.dart';
import '../screens/edit_plan_screen.dart';

class PlanProvider extends ChangeNotifier {
  List<Plan> _plans = [];

  List<Plan> get getPlans {
    return [..._plans];
  }

  Plan getCurrentEditedPlan(BuildContext context) {
    return Provider.of<UserProvider>(context, listen: false)
        .getPlanById(_current_edited_plan);
  }

  void updateCurrentEditedPlan(Plan plan, [bool cloud_update = false]) {
    updatePlan(plan, cloud_update);
  }

  void updatePlan(Plan plan, [bool cloud_update = false]) {
    int index = _plans.map((e) => e.id).toList().indexOf(plan.id);

    if (index == -1) {
      // plans doesn't have plan?!?!
      return;
    }

    _plans[index] = plan;

    if (cloud_update) {
      setData(plan);
    }
  }

  void setCurrentEditedPlanId(String new_id) {
    _current_edited_plan = new_id;
  }

  String _current_edited_plan = '';

  Future<void> deletePlanByName(String name) async {
    await FirebaseFirestore.instance.collection('plans').doc(name).delete();
  }

  List<Plan> getPlansOfUser(String uid) {
    return _plans.where((item) => item.user_id == uid).toList();
  }

  Future<void> addData(Plan plan, BuildContext context) async {
    if (getPlans.map((e) => e.id).contains(plan.id)) {
      await setData(plan);

      debugPrint('Plan already exists, replacing data');
      return;
    }

    await FirebaseFirestore.instance.collection('plans').add({
      'exercises_in_plan': plan.exercises_in_plan.toList(),
      'name': plan.name,
      'user_id': plan.user_id
    }).then((doc) => {
          plan.id = doc.id,
          _plans.add(Plan(
              exercises_in_plan: plan.exercises_in_plan,
              name: plan.name,
              user_id: plan.user_id,
              id: doc.id)),
          Provider.of<UserProvider>(context, listen: false).addPlan(plan)
        });

    //notifyListeners();
  }

  Future<void> fetchPlans(BuildContext context) async {
    await FirebaseFirestore.instance.collection("plans").get().then(
      (querySnapshot) {
        print("Successfully fetched exercises!");
        for (var doc in querySnapshot.docs) {
          if (_plans.map((e) => e.id).contains(doc.id) == true) continue;

          if (doc['user_id'] == null || doc['user_id'] == '') continue;

          _plans.add(Plan(
              name: doc['name'] ?? '',
              exercises_in_plan: doc['exercises_in_plan'] == null
                  ? []
                  : List.from(doc['exercises_in_plan'] as Iterable<dynamic>),
              user_id: doc['user_id'] ?? '',
              id: doc.id));
        }
        debugPrint("Successfully added exercises to list!");
      },
      onError: (e) => debugPrint("Error completing: $e"),
    );

    notifyListeners();
  }

  List<ExerciseInPlan> exercisesInPlanFromIds(
      List<String> ids, BuildContext context) {
    if (ids.isEmpty) return [];
    List<ExerciseInPlan> lst = [];
    for (String id in ids) {
      lst.add(Provider.of<ExerciseInPlanProvider>(context, listen: false)
          .getExerciseInPlanById(id));
    }
    return lst;
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

  Future<void> setData(Plan plan) async {
    await FirebaseFirestore.instance.collection('plans').doc(plan.id).set({
      'exercises_in_plan': plan.exercises_in_plan,
      'name': plan.name,
      'user_id': plan.user_id
    });
    _plans.add(plan);

    //notifyListeners();
  }

  Plan getPlanFromExerciseInPlan(ExerciseInPlan exerciseInPlan) {
    return getPlanById(exerciseInPlan.exercise_id);
  }

  Plan getPlanByName(String name) {
    if (_plans.isEmpty)
      return Plan(exercises_in_plan: [], name: '', user_id: '', id: '');

    return _plans.firstWhere((element) => element.name == name);
  }

  Plan getPlanById(String planId) {
    if (_plans.isEmpty)
      return Plan(exercises_in_plan: [], name: '', user_id: '', id: '');

    return _plans.firstWhere((element) => element.id == planId);
  }

  Future<void> deletePlanInUser(Plan plan, BuildContext context) async {
    _plans.removeWhere((element) => element.id == plan.id);
    UserProfile userProfile =
        Provider.of<UserProvider>(context, listen: false).myUser;

    // Remove plan from user's plans.
    await FirebaseFirestore.instance
        .collection('users')
        .doc(plan.user_id)
        .update({
      'plans': _plans.map((e) => e.id).toList(),
      // 'first_name': userProfile.first_name,
      // 'last_name': userProfile.last_name,
      // 'username': userProfile.username,
      // 'age': userProfile.age,
      // 'weight': userProfile.weight,
      // 'height': userProfile.height,
      // 'email': userProfile.email
    });

    // Remove plan from plans.
    await FirebaseFirestore.instance.collection('plans').doc(plan.id).delete();

    await deleteExercisesInPlanOfPlanByPlanId(plan.id, context);

    notifyListeners();
  }

  Future<void> deleteExercisesInPlanOfPlanByPlanId(
      String id, BuildContext context) async {
    List<ExerciseInPlan> lst = List.from(
        Provider.of<ExerciseInPlanProvider>(context, listen: false)
            .ExercisesInPlanList);

    for (ExerciseInPlan exerciseInPlan in lst) {
      if (exerciseInPlan.plan_id == id) {
        Provider.of<ExerciseInPlanProvider>(context, listen: false)
            .removeExerciseInPlan(exerciseInPlan);
      }
    }
  }
}
