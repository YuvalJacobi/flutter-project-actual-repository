import 'package:flutter_complete_guide/model/ingredient.dart';

class Dish {
  String name;

  List<Ingredient> ingredients;

  List<String> instructions;

  double cooking_time_in_minutes;

  String dish_id;

  String daily_plan_id;

  Dish(
      {this.name,
      this.ingredients,
      this.cooking_time_in_minutes,
      this.instructions,
      this.daily_plan_id});
}
