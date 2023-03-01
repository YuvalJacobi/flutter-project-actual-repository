import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_complete_guide/model/dish.dart';
import 'package:flutter_complete_guide/model/ingredient.dart';

class DishProvider extends ChangeNotifier {
  List<Dish> _dishes;

  List<Dish> get dishes {
    return [..._dishes];
  }

  List<Dish> getDishesByDailyPlanId(String daily_plan_id) {
    return _dishes.where((element) => element.daily_plan_id == daily_plan_id);
  }

  Dish getDishById(String dish_id) {
    return _dishes.firstWhere((element) => element.dish_id == dish_id);
  }

  DishProvider();

  Future<void> fetchData() {
    FirebaseFirestore.instance
        .collection('ingredients')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        _dishes.add(Dish({
          doc['name'],
          doc['ingredients'],
          doc['cooking_time_in_minutes'],
          doc['instructions'],
          doc['daily_plan_id'],
          doc.id,
        }));
      });
    });
  }

  String stringify(Dish dish) {
    String t = '';

    t += 'Name: ${dish.name}\n';

    t += 'Cooking time in minutes: ${dish.cooking_time_in_minutes}';

    return t;
  }
}
