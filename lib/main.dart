import 'package:flutter/material.dart';
import 'package:food_recipes/providers/all_recipe_provider.dart';
import 'package:food_recipes/providers/fav_provider.dart';
import 'package:food_recipes/providers/recipe_provider.dart';
import 'package:food_recipes/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'providers/category_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CategoryProvider()),
        ChangeNotifierProvider(create: (context) => RecipeProvider()),
        ChangeNotifierProvider(create: (context) => FavoritesProvider()),
        ChangeNotifierProvider(create: (context) => AllRecipeProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Food Recipes',
        home: SplashScreen(),
      ),
    );
  }
}
