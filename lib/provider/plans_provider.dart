import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/model/exercise_in_plan.dart';
import 'package:flutter_complete_guide/provider/user_provider.dart';
import 'package:provider/provider.dart';

import '../model/plan.dart';
import '../screens/edit_plan_screen.dart';

class PlanProvider extends ChangeNotifier {
  List<Plan> plans = [];

  Plan? currently_played_plan = null;

  List<Plan> get getPlans {
    return [...plans];
  }

  Plan? getCurrentEditedPlan() {
    return current_edited_plan;
  }

  Plan? current_edited_plan = null;

  Future<void> deletePlanByName(String name) async {
    await FirebaseFirestore.instance.collection('plans').doc(name).delete();
  }

  List<Plan> getPlansOfUser(String uid) {
    return plans.where((item) => item.user_id == uid).toList();
  }

  Future<void> addData(Plan plan, BuildContext context) async {
    if (getPlans.map((e) => e.id).contains(plan.id)) {
      await setData(plan);

      debugPrint('Plan already exists, replacing data');
      return;
    }

    await FirebaseFirestore.instance.collection('plans').add({
      'exercises_in_plan':
          plan.exercises.map((e) => exerciseInPlanToMap(e)).toList(),
      'name': plan.name,
      'user_id': plan.user_id
    }).then((doc) => {
          plan.id = doc.id,
          plans.add(Plan(
              exercises: plan.exercises,
              name: plan.name,
              user_id: plan.user_id,
              id: doc.id)),
          Provider.of<UserProvider>(context, listen: false).addPlan(plan)
        });

    Provider.of<UserProvider>(context, listen: false).updatePlanOfUser(plan);

    Provider.of<PlanProvider>(context, listen: false).current_edited_plan =
        plan;

    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPlanScreen(),
      ),
    );

    //notifyListeners();
  }

  Future<void> fetchPlans() async {
    await FirebaseFirestore.instance.collection("plans").get().then(
      (querySnapshot) {
        print("Successfully fetched exercises!");
        for (var doc in querySnapshot.docs) {
          plans.add(Plan(
              name: doc['name'] ?? '',
              exercises: doc['exercises_in_plan'] == null
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
    List<ExerciseInPlan> lst = plan.exercises;

    await FirebaseFirestore.instance
        .collection('plans')
        .doc(plan.id.isEmpty ? null : plan.id)
        .set({
      'exercises_in_plan': lst.map((e) => exerciseInPlanToMap(e)).toList(),
      'name': plan.name,
      'user_id': plan.user_id
    });
    plans.add(plan);

    //notifyListeners();
  }

  Plan getPlanFromExerciseInPlan(ExerciseInPlan exerciseInPlan) {
    return getPlanById(exerciseInPlan.exercise_id);
  }

  Plan getPlanById(String planId) {
    return plans.firstWhere((element) => element.id == planId);
  }

  Future<void> deletePlanInUser(Plan plan) async {
    plans.removeWhere((element) => element.id == plan.id);

    // Remove plan from user's plans.
    await FirebaseFirestore.instance
        .collection('users')
        .doc(plan.user_id)
        .set({'plans': plans});

    // Remove plan from plans.
    await FirebaseFirestore.instance.collection('plans').doc(plan.id).delete();

    notifyListeners();
  }
}
