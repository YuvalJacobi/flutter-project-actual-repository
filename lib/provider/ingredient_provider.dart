import 'package:flutter/cupertino.dart';

import '../model/ingredient.dart';

class IngredientProvider extends ChangeNotifier {
  List<Ingredient> _ingredients;

  List<Ingredient> get ingredients {
    return [..._ingredients];
  }

  Ingredient getIngredientById(String ingredient_id) {
    return _ingredients
        .firstWhere((element) => element.ingredient_id == ingredient_id);
  }

  IngredientProvider();
}
