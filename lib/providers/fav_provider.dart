import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/recipe_model.dart';

class FavoritesProvider extends ChangeNotifier {
  List<RecipeModel> _favorites = [];

  List<RecipeModel> get favorites => _favorites;

  FavoritesProvider() {
    _loadFavorites();
  }

  void _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedFavorites = prefs.getString('favorites');
    if (savedFavorites != null) {
      _favorites = (json.decode(savedFavorites) as List)
          .map((data) => RecipeModel.fromJson(data))
          .toList();
      notifyListeners();
    }
  }

  void addFavorite(RecipeModel recipe) async {
    _favorites.add(recipe);
    print("Added favorite: ${recipe.title}");
    notifyListeners();
    _saveFavorites();
  }

  void removeFavorite(RecipeModel recipe) async {
    _favorites.removeWhere((item) => item.recipeId == recipe.recipeId);
    print("Removed favorite: ${recipe.title}");
    notifyListeners();
    _saveFavorites();
  }

  bool isFavorite(RecipeModel recipe) {
    return _favorites.any((item) => item.recipeId == recipe.recipeId);
  }

  void _saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedData =
    json.encode(_favorites.map((recipe) => recipe.toJson()).toList());
    await prefs.setString('favorites', encodedData);
    print("Saved favorites: $encodedData");
  }
}

