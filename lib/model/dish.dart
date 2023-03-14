import 'package:flutter_complete_guide/model/ingredient.dart';

class Dish {
  String name;

  Map<String, Ingredient> ingredients;

  List<String> instructions;

  double cooking_time_in_minutes;

  String daily_plan_id;

  String dish_id;

  Dish(Set set,
      {this.name,
      this.ingredients,
      this.cooking_time_in_minutes,
      this.instructions,
      this.daily_plan_id,
      this.dish_id});
}
