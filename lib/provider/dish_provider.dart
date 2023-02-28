import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_complete_guide/model/dish.dart';

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
}
