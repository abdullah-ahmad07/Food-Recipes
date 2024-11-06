import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/category_model.dart';

class CategoryProvider with ChangeNotifier {
  List<CategoryModel> _categories = [];

  List<CategoryModel> get categories => _categories;

  Future<void> fetchCategories() async {
    const url = 'https://digitalprimeagency.com/zoncoapps/foodRecipes/AllCategory.php';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);


        final List<dynamic> categoryList = data['categoryList'];

        _categories = categoryList
            .map((categoryJson) => CategoryModel.fromJson(categoryJson))
            .toList();

        notifyListeners();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (error) {
      rethrow;
    }
  }
}
