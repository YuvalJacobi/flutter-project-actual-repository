import 'dart:ffi';
import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_complete_guide/model/dish.dart';
import 'package:flutter_complete_guide/provider/ingredient_provider.dart';
import 'package:provider/provider.dart';

import '../model/ingredient.dart';

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

  double getTotalPriceOfDishById(String dish_id) {
    Dish dish = _dishes.firstWhere((element) => element.dish_id == dish_id);

    var total_price = 0.0;
    dish.ingredients.values.forEach((element) {
      total_price += element.price;
    });

    return total_price;
  }

  DishProvider();

  Future<void> setData(Dish dish) {
    FirebaseFirestore.instance.collection('dishes').doc(dish.dish_id).set({
      'name': dish.name,
      'ingredients': dish.ingredients,
      'cooking_time_in_minutes': dish.cooking_time_in_minutes,
      'instructions': dish.instructions,
      'daily_plan_id': dish.daily_plan_id,
    });
  }

  Future<void> addData(Dish dish) {
    FirebaseFirestore.instance.collection('dishes').add({
      'name': dish.name,
      'ingredients': dish.ingredients,
      'cooking_time_in_minutes': dish.cooking_time_in_minutes,
      'instructions': dish.instructions,
      'daily_plan_id': dish.daily_plan_id,
    }).then((DocumentReference docref) {
      dish.dish_id = docref.id;
    });
  }

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

  bool isValidDish(Dish dish) {
    if (dish.cooking_time_in_minutes <= 0) return false;

    if (dish.daily_plan_id.isEmpty || dish.daily_plan_id == '') return false;

    if (dish.dish_id == 0) return false;

    if (dish.ingredients.isEmpty || dish.ingredients == null) return false;

    if (dish.instructions.isEmpty || dish.instructions == null) return false;

    if (dish.name.isEmpty || dish.name == '') return false;

    return true;
  }

  String stringify(Dish dish) {
    if (isValidDish(dish) == false) return '';

    String t = '';

    t += 'Name: ${dish.name}\n';

    t += 'Cooking time in minutes: ${dish.cooking_time_in_minutes}\n';

    if (dish.ingredients.values
        .any((element) => isValidIngredient(element) == false)) return t;

    dish.ingredients.forEach((key, value) {
      t += '${adjustStringRepresentation(key)}: ${value}\n';
    });

    return t;
  }

  bool isValidIngredient(Ingredient ingredient) {
    if (ingredient.name.isEmpty || ingredient.name == '') return false;

    if (ingredient.price <= 0) return false;

    if (ingredient.base_serving <= 0) return false;

    if (ingredient.carbohydrates < 0) return false;

    if (ingredient.sugar < 0) return false;

    if (ingredient.protein < 0) return false;

    if (ingredient.sodium < 0) return false;

    if (ingredient.fat < 0) return false;

    if (ingredient.ingredient_id.isEmpty || ingredient.ingredient_id == '')
      return false;

    return true;
  }

  String adjustStringRepresentation(String string) {
    if (string.isEmpty) return '';

    String s = string.substring(1);
    String c = string[0].toUpperCase();

    return c + s.replaceAll('_', ' ');
  }
}
