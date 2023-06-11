import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/model/exercise_in_plan.dart';
import 'package:flutter_complete_guide/provider/exercise_in_plan_provider.dart';
import 'package:flutter_complete_guide/provider/user_provider.dart';
import 'package:provider/provider.dart';

import '../model/plan.dart';

class PlanProvider extends ChangeNotifier {
  /// variable for storing plans.
  List<Plan> _plans = [];

  List<Plan> get getPlans {
    return [..._plans];
  }

  Plan getCurrentEditedPlan(BuildContext context) {
    /// return current edited plan.
    return Provider.of<UserProvider>(context, listen: false)
        .getPlanById(_current_edited_plan);
  }

  Future<void> updateCurrentEditedPlan(Plan plan,
      [bool cloud_update = false]) async {
    /// update plan with toggle for updating in database.
    await updatePlan(plan, cloud_update);
  }

  Future<void> updatePlan(Plan plan, [bool cloud_update = false]) async {
    /// update plan with toggle for updating in database.
    int index = _plans.map((e) => e.id).toList().indexOf(plan.id);

    if (index == -1) {
      // plans doesn't have plan?!?!
      return;
    }

    /// update plan's new values inside local list.
    _plans[index] = plan;

    if (cloud_update) {
      /// update in firebase.
      await setData(plan);
    }
  }

  void setCurrentEditedPlanId(String new_id) {
    /// set current edited plan's id.
    _current_edited_plan = new_id;
  }

  // variable for storing current edited plan's id.
  String _current_edited_plan = '';

  List<Plan> getPlansOfUser(String uid) {
    // get all plans belonging to user.
    return _plans.where((item) => item.user_id == uid).toList();
  }

  Future<void> addData(Plan plan, BuildContext context) async {
    /// add new plan to database.
    if (getPlans.map((e) => e.id).contains(plan.id)) {
      /// the plan already exists, updating it instead.
      await setData(plan);

      debugPrint('Plan already exists, replacing data');
      return;
    }

    /// add new plan to database with the provided values.
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
  }

  Future<void> fetchPlans(BuildContext context) async {
    /// fetch all plans from database.
    await FirebaseFirestore.instance.collection("plans").get().then(
      (querySnapshot) {
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
      },
      onError: (e) => debugPrint("Error completing: $e"),
    );
  }

  List<ExerciseInPlan> exercisesInPlanFromIds(

      /// get all exercises in plan by their ids.
      List<String> ids,
      BuildContext context) {
    if (ids.isEmpty) return [];
    List<ExerciseInPlan> lst = [];
    for (String id in ids) {
      lst.add(Provider.of<ExerciseInPlanProvider>(context, listen: false)
          .getExerciseInPlanById(id));
    }
    return lst;
  }

  Map<String, dynamic> exerciseInPlanToMap(ExerciseInPlan exerciseInPlan) {
    /// convert exercise in plan object to a Map form.
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
    /// set data of alrady existing plan into database.
    await FirebaseFirestore.instance.collection('plans').doc(plan.id).set({
      'exercises_in_plan': plan.exercises_in_plan,
      'name': plan.name,
      'user_id': plan.user_id
    });
    _plans.add(plan);
  }

  Plan getPlanFromExerciseInPlan(ExerciseInPlan exerciseInPlan) {
    /// get plan from exercise in plan.
    return getPlanById(exerciseInPlan.exercise_id);
  }

  Plan getPlanByName(String name) {
    // get plan by its name.
    if (_plans.isEmpty)
      return Plan(exercises_in_plan: [], name: '', user_id: '', id: '');

    return _plans.firstWhere((element) => element.name == name);
  }

  Plan getPlanById(String planId) {
    /// get plan by its id
    if (_plans.isEmpty)
      return Plan(exercises_in_plan: [], name: '', user_id: '', id: '');

    return _plans.firstWhere((element) => element.id == planId);
  }

  Future<void> deletePlanInUser(Plan plan, BuildContext context) async {
    /// delete plan in local list.
    _plans.removeWhere((element) => element.id == plan.id);

    Provider.of<UserProvider>(context, listen: false).my_plans.remove(plan);

    // Remove plan from user's plans.
    await FirebaseFirestore.instance
        .collection('users')
        .doc(plan.user_id)
        .update({
      'plans': _plans.map((e) => e.id).toList(),
    });

    // Remove plan from plans.
    await FirebaseFirestore.instance.collection('plans').doc(plan.id).delete();

    await deleteExercisesInPlanOfPlanByPlanId(plan.id, context);
  }

  Future<void> deleteExercisesInPlanOfPlanByPlanId(
      String id, BuildContext context) async {
    /// delete exercise in plan from plan's exercises in plan by plan id.
    List<ExerciseInPlan> lst = List.from(
        Provider.of<ExerciseInPlanProvider>(context, listen: false)
            .ExercisesInPlanList);

    for (ExerciseInPlan exerciseInPlan in lst) {
      if (exerciseInPlan.plan_id == id) {
        Provider.of<ExerciseInPlanProvider>(context, listen: false)
            .removeExerciseInPlan(exerciseInPlan, context);
      }
    }
  }
}
