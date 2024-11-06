
class RecipeModel {
  final String recipeId;
  final String title;
  final String timeTitle;
  final String time;
  final String ingredients;
  final String instructions;
  final String serves;
  final String notes;
  final String imageUrl;

  RecipeModel({
    required this.recipeId,
    required this.title,
    required this.timeTitle,
    required this.time,
    required this.ingredients,
    required this.instructions,
    required this.serves,
    required this.notes,
    required this.imageUrl,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      recipeId: json['recipeId'] ?? '',
      title: json['recipeTitle'] ?? '',
      timeTitle: json['recipeTimeTtitle'] ?? '',
      time: json['recipeTimes'] ?? '',
      ingredients: json['recipeIngredients'] ?? '',
      instructions: json['recipeInstructions'] ?? '',
      serves: json['recipeServes'] ?? '',
      notes: json['recipeNotes'] ?? '',
      imageUrl: json['recipeImage'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'recipeId': recipeId,
      'recipeTitle': title,
      'recipeTimeTtitle': timeTitle,
      'recipeTimes': time,
      'recipeIngredients': ingredients,
      'recipeInstructions': instructions,
      'recipeServes': serves,
      'recipeNotes': notes,
      'recipeImage': imageUrl,
    };
  }
}
