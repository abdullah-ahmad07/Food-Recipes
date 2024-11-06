import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../models/recipe_model.dart';

class RecipeProvider with ChangeNotifier {
  List<RecipeModel> _recipes = [];
  bool _isLoading = false;

  List<RecipeModel> get recipes => _recipes;
  bool get isLoading => _isLoading;

  Future<void> fetchRecipes(String recipeCatId) async {
    final url = Uri.parse(
        'https://digitalprimeagency.com/zoncoapps/foodRecipes/Response.php');

    _isLoading = true;
    _recipes = [];
    notifyListeners();

    try {
      print("Fetching recipes with recipeCatId: $recipeCatId");
      final response = await http.post(url, body: {'recipeCatId': recipeCatId});
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Decoded Data: $data");

        if (data['recipelist'] != null && data['recipelist'] is List) {
          _recipes = (data['recipelist'] as List)
              .map((recipeJson) =>
              RecipeModel.fromJson(recipeJson as Map<String, dynamic>))
              .toList();
          print("Recipes Loaded: ${_recipes.length} recipes found.");
        } else {
          print("Error: 'recipelist' is null or not a list");
          _recipes = [];
        }
      } else {
        print("Error: Failed to load recipes with status code ${response.statusCode}");
        _recipes = [];
        throw Exception('Failed to load recipes');
      }
    } catch (error) {
      print("Exception caught: $error");
      _recipes = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
