import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/model/exercise.dart';

class ExerciseProvider extends ChangeNotifier {
  List<Exercise> _exercises = [];

  List<Exercise> get exercises {
    return [..._exercises];
  }

  List<Exercise> getExercisesByCategory(String category) {
    return _exercises.where((element) => element.category == category).toList();
  }

  List<Exercise> getExercisesByLevel(String level) {
    return _exercises.where((element) => element.level == level).toList();
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

  List<Exercise> getExercisesWithSorting({
    String name = '',
    String category = '',
    required List<String> active_muscles,
    String level = '',
  }) {
    return _exercises
        .where((element) =>
            (element.name.contains(name) || name == '') &&
            (element.category == category || category == '') &&
            (doListContainsList(element.active_muscles, active_muscles) ||
                active_muscles.isEmpty) &&
            (element.level == level || level == ''))
        .toList();
  }

  Future<void> fetchExercises() async {
    await FirebaseFirestore.instance.collection("exercises").get().then(
      (querySnapshot) {
        print("Successfully fetched exercises!");
        for (var doc in querySnapshot.docs) {
          _exercises.add(Exercise(
              name: doc['name'],
              category: doc['category'],
              active_muscles: (doc['active_muscles'] as List<dynamic>).cast(),
              level: doc['level'],
              image_url: doc['image_url'],
              id: doc.id));
        }
        debugPrint("Successfully added exercises to list!");
      },
      onError: (e) => debugPrint("Error completing: $e"),
    );

    notifyListeners();
  }

  Future<void> addData(Exercise exercise) async {
    if (exercises.map((e) => e.id).contains(exercise.id)) {
      debugPrint("Exercise already exists within database!");
      return;
    }
    await FirebaseFirestore.instance.collection('exercises').add({
      'name': exercise.name,
      'active_muscles': exercise.active_muscles,
      'category': exercise.category,
      'image_url': exercise.image_url,
      'level': exercise.level
    }).then((doc) => {
          exercise.id = doc.id,
          debugPrint("Successfully added exercise: " + exercise.toString()),
          _exercises.add(exercise),
        });

    debugPrint("Finished await");
  }
}
