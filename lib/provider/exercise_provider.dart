import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/model/exercise.dart';

class ExerciseProvider extends ChangeNotifier {
  /// list of exercises
  List<Exercise> _exercises = [];

  List<Exercise> get exercises {
    return [..._exercises];
  }

  /// check if a list is contained in another list
  bool doListContainsList(List<dynamic> lst1, List<dynamic> lst2) {
    if (lst2.isEmpty) return true;

    for (int index in lst2) {
      if (lst1.contains(lst2.indexOf(index)) == false) {
        return false;
      }
    }
    return true;
  }

  /// get list of exercises with sorting arguments.
  List<Exercise> getExercisesWithSorting(
      {String name = '',
      String category = '',
      required List<String> active_muscles,
      String level = '',
      String exercise_id = ''}) {
    return _exercises
        .where((element) =>
            (element.name.contains(name) || name == '') &&
            (element.category == category || category == '') &&
            (doListContainsList(element.active_muscles, active_muscles) ||
                active_muscles.isEmpty) &&
            (element.level == level || level == '') &&
            (element.exercise_id == exercise_id || exercise_id == ''))
        .toList();
  }

  /// fetch all exercises from database.
  Future<void> fetchExercises() async {
    await FirebaseFirestore.instance.collection("exercises").get().then(
      (querySnapshot) {
        print("Successfully fetched exercises!");
        for (var doc in querySnapshot.docs) {
          if (_exercises.map((e) => e.exercise_id).contains(doc.id)) continue;

          if (doc['name'] == null || doc['name'] == '') continue;
          _exercises.add(Exercise(
              name: doc['name'] ?? '',
              category: doc['category'] ?? '',
              active_muscles: doc['active_muscles'] == null
                  ? []
                  : List.from(doc['active_muscles'] as Iterable<dynamic>),
              level: doc['level'] ?? '',
              image_url: doc['image_url'] ?? '',
              exercise_id: doc.id));
        }
        debugPrint("Successfully added exercises to list!");
      },
      onError: (e) => debugPrint("Error completing: $e"),
    );
  }
}
