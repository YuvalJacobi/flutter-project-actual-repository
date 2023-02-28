import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_complete_guide/model/dish.dart';

class Ingredient {
  String name;

  double price;

  double base_serving;

  double calories;

  double carbohydrates;

  double sugar;

  double protein;

  double sodium;

  double fat;

  String ingredient_id;

  Ingredient(
      {this.name,
      this.price,
      this.base_serving,
      this.calories,
      this.carbohydrates,
      this.sugar,
      this.protein,
      this.sodium,
      this.fat,
      this.ingredient_id});
}
