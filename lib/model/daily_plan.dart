import 'package:flutter_complete_guide/model/ingredient.dart';

import 'dish.dart';

class DailyPlan {
  String name;

  String day;

  String author_id;

  List<Dish> dishes;

  String daily_plan_id;

  DailyPlan(
      {this.name, this.day, this.author_id, this.dishes, this.daily_plan_id});
}
