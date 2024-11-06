import 'package:flutter/material.dart';
import 'package:food_recipes/consts/app_colors.dart';
import 'package:food_recipes/screens/all_recipe_screen.dart';
import 'package:provider/provider.dart';
import '../consts/assets.dart';
import '../models/recipe_model.dart';
import '../providers/fav_provider.dart';
import 'recipe_detail_screen.dart';

class FavoriteRecipesScreen extends StatefulWidget {
  const FavoriteRecipesScreen({super.key});

  @override
  State<FavoriteRecipesScreen> createState() => _FavoriteRecipesScreenState();
}

class _FavoriteRecipesScreenState extends State<FavoriteRecipesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<RecipeModel> _filteredRecipes = [];
  final List<RecipeModel> _allRecipes = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterRecipes(String query) {
    final filtered = _allRecipes
        .where((recipe) =>
            recipe.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      _filteredRecipes = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        foregroundColor: Colors.white,
        title: const Text('My Favorite Recipes'),
        backgroundColor: FoodColors.mainColor,
      ),
      body: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, child) {
          List<RecipeModel> favorites = favoritesProvider.favorites;

          if (favorites.isEmpty) {
            return _buildNoFavoriteScreen(context);
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  cursorColor: FoodColors.mainColor,
                  controller: _searchController,
                  onChanged: _filterRecipes,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: FoodColors.mainColor),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: FoodColors.mainColor),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    hintText: '  Search Recipe...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(
                        "assets/icons/search.png",
                        height: 15,
                        width: 15,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: FoodColors.mainColor),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    RecipeModel recipe = favorites[index];
                    final recipeTimes = recipe.time;
                    List<String> timeParts = recipeTimes
                        .split(',')
                        .where((part) => part.trim().isNotEmpty)
                        .toList();

                    final totalTime =
                        timeParts.length > 2 ? timeParts[2].trim() : 'N/A';
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailScreen(
                              recipeModel: recipe,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                            side: BorderSide(
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          elevation: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  height: 120,
                                  width: double.infinity,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(18),
                                    child: Image.network(
                                      recipe.imageUrl,
                                      height: 120,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          height: 180,
                                          width: double.infinity,
                                          color: Colors.grey,
                                          child: const Icon(
                                            Icons.error,
                                            color: Colors.white,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10),
                                    Text(
                                      recipe.title,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              FoodAssets.clock,
                                              height: 20,
                                              width: 20,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              'Cooking Time: $totalTime',
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 10),
                                        IconButton(
                                          icon: Image.asset(
                                            FoodAssets.arrow,
                                            height: 20,
                                            width: 20,
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    RecipeDetailScreen(
                                                  recipeModel: recipe,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNoFavoriteScreen(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/no favorite.png',
            height: 200,
            width: 200,
          ),
          const SizedBox(height: 20),
          const Text(
            'No Favorite Recipe',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: FoodColors.mainColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const AllRecipesScreen(),
                ),
              );
            },
            child: const Text(
              'View Recipes',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
