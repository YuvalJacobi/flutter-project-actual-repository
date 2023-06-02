import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/model/exercise.dart';

class ExerciseProvider extends ChangeNotifier {
  List<Exercise> _exercises = [];

  List<Exercise> get exercises {
    return [..._exercises];
  }

  bool doListContainsList(List<dynamic> lst1, List<dynamic> lst2) {
    if (lst2.isEmpty) return true;

    for (int index in lst2) {
      if (lst1.contains(lst2.indexOf(index)) == false) {
        return false;
      }
    }
    return true;
  }

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

    //notifyListeners();
  }

  Future<void> addData(Exercise exercise) async {
    if (exercises.map((e) => e.exercise_id).contains(exercise.exercise_id)) {
      debugPrint("Exercise already exists within database!");
      return;
    }
    await FirebaseFirestore.instance.collection('exercises').add({
      'name': exercise.name,
      'active_muscles': exercise.active_muscles,
      'category': exercise.category,
      'image_url': exercise.image_url,
      'level': exercise.level,
    }).then((doc) => {
          exercise.exercise_id = doc.id,
          debugPrint("Successfully added exercise: " + exercise.toString()),
          _exercises.add(exercise),
        });

    debugPrint("Finished await");
  }
}
