import 'package:flutter/material.dart';
import 'package:food_recipes/providers/all_recipe_provider.dart';
import 'package:provider/provider.dart';
import '../consts/app_colors.dart';
import '../consts/assets.dart';
import '../models/recipe_model.dart';
import 'recipe_detail_screen.dart';

class AllRecipesScreen extends StatefulWidget {
  const AllRecipesScreen({super.key});

  @override
  State<AllRecipesScreen> createState() => _AllRecipesScreenState();
}

class _AllRecipesScreenState extends State<AllRecipesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<RecipeModel> _filteredRecipes = [];
  List<RecipeModel> _allRecipes = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final recipeProvider = Provider.of<AllRecipeProvider>(context, listen: false);
      recipeProvider.fetchRecipes().then((_) {
        setState(() {
          _allRecipes = recipeProvider.recipes;
          _filteredRecipes = _allRecipes;
        });
      });
    });
  }

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        foregroundColor: Colors.white,
        title: const Text('All Recipes'),
        centerTitle: true,
        backgroundColor: FoodColors.mainColor,
      ),
      body: Column(
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
            child: Consumer<AllRecipeProvider>(
              builder: (context, recipeProvider, child) {
                if (recipeProvider.isLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: FoodColors.mainColor,
                    ),
                  );
                }

                if (_filteredRecipes.isEmpty) {
                  return const Center(
                    child: Text('No recipes available.'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: _filteredRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = _filteredRecipes[index];
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
