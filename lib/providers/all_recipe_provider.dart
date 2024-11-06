import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/recipe_model.dart';

class AllRecipeProvider with ChangeNotifier {
  List<RecipeModel> _recipes = [];
  List<RecipeModel> get recipes => _recipes;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchRecipes() async {
    _isLoading = true;
    notifyListeners();

    const url = "https://digitalprimeagency.com/zoncoapps/foodRecipes/allrecipes.php";

    try {
      final response = await http.post(Uri.parse(url));

      // Print response status and body to check if it's returning the correct data
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Ensure that the 'recipelist' is present and check its structure
        print('Parsed data: $data');

        if (data['recipelist'] != null) {
          final List<RecipeModel> loadedRecipes = [];

          // Iterate over the recipelist and populate the recipes
          for (var recipeData in data['recipelist']) {
            print('Recipe data: $recipeData'); // Check each recipe item
            loadedRecipes.add(RecipeModel.fromJson(recipeData));
          }

          _recipes = loadedRecipes;
          print('Loaded recipes: $_recipes'); // Check if recipes are loaded correctly
        } else {
          print('No recipelist found in the API response.');
        }
      } else {
        throw Exception('Failed to load recipes');
      }
    } catch (error) {
      print('Error fetching recipes: $error');
    }

    _isLoading = false;
    notifyListeners();
  }


}
