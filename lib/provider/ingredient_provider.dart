import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<void> setData(Ingredient ingredient) {
    FirebaseFirestore.instance
        .collection('ingredients')
        .doc(ingredient.ingredient_id)
        .set({
      'name': ingredient.name,
      'price': ingredient.price,
      'base_serving': ingredient.base_serving,
      'calories': ingredient.calories,
      'carbohydrates': ingredient.carbohydrates,
      'sugar': ingredient.sugar,
      'protein': ingredient.protein,
      'sodium': ingredient.sodium,
      'fat': ingredient.fat,
    });
  }

  Future<void> addData(Ingredient ingredient) {
    FirebaseFirestore.instance.collection('ingredients').add({
      'name': ingredient.name,
      'price': ingredient.price,
      'base_serving': ingredient.base_serving,
      'calories': ingredient.calories,
      'carbohydrates': ingredient.carbohydrates,
      'sugar': ingredient.sugar,
      'protein': ingredient.protein,
      'sodium': ingredient.sodium,
      'fat': ingredient.fat,
    }).then((DocumentReference docref) {
      ingredient.ingredient_id = docref.id;
    });
  }

  Future<void> fetchData() {
    FirebaseFirestore.instance
        .collection('ingredients')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        _ingredients.add(Ingredient({
          doc['name'],
          doc['price'],
          doc['base_serving'],
          doc['calories'],
          doc['carbohydrates'],
          doc['sugar'],
          doc['protein'],
          doc['sodium'],
          doc['fat'],
          doc.id,
        }));
      });
    });
  }

  Ingredient scaleIngredientByAmount(Ingredient ingredient, double amount) {
    return scaleIngredientByGrams(ingredient, ingredient.base_serving * amount);
  }

  double scaleData(double data, double base_serving, double grams) {
    return data * grams / base_serving;
  }

  Ingredient scaleIngredientByGrams(Ingredient ingredient, double grams) {
    return Ingredient({
      ingredient.name,
      scaleData(ingredient.price, ingredient.base_serving, grams),
      ingredient.base_serving,
      scaleData(ingredient.calories, ingredient.base_serving, grams),
      scaleData(ingredient.carbohydrates, ingredient.base_serving, grams),
      scaleData(ingredient.sugar, ingredient.base_serving, grams),
      scaleData(ingredient.protein, ingredient.base_serving, grams),
      scaleData(ingredient.sodium, ingredient.base_serving, grams),
      scaleData(ingredient.fat, ingredient.base_serving, grams)
    });
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

  String stringify(Ingredient ingredient) {
    if (isValidIngredient(ingredient) == false) return '';

    String t = '';

    t += 'Name: ${ingredient.name}\n';

    t += 'Price: ${ingredient.price}\n';

    t += 'Base serving: ${ingredient.base_serving}\n';

    t += 'Calories: ${ingredient.calories}\n';

    t += 'Carbohydrates: ${ingredient.carbohydrates}\n';

    t += 'Sugar: ${ingredient.sugar}\n';

    t += 'Fat: ${ingredient.fat}\n';

    t += 'Sodium: ${ingredient.sodium}\n';

    return t;
  }
}
