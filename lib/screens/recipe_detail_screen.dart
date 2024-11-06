import 'package:flutter/material.dart';
import 'package:food_recipes/consts/app_colors.dart';
import 'package:food_recipes/consts/assets.dart';
import 'package:food_recipes/models/recipe_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/fav_provider.dart';

class RecipeDetailScreen extends StatefulWidget {
  final RecipeModel recipeModel;

  const RecipeDetailScreen({super.key, required this.recipeModel});

  @override
  State<StatefulWidget> createState() {
    return _RecipeDetailScreenState();
  }
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  int _selectedIndex = 0;
  final pw.Document pdf = pw.Document();


  Future<void> _generateAndPreviewPDF() async {
    final recipe = widget.recipeModel;
    final pdf = pw.Document();

    List<String> timeParts = recipe.time
        .split(',')
        .where((part) => part.trim().isNotEmpty)
        .toList();

    final cookTime = timeParts.isNotEmpty ? timeParts[0].trim() : 'N/A';
    final prepTime = timeParts.length > 1 ? timeParts[1].trim() : 'N/A';
    final totalTime = timeParts.length > 2 ? timeParts[2].trim() : 'N/A';

    final ingredients = recipe.ingredients.split(',,');
    final instructions = recipe.instructions.split(',,');
    final servedInstructions = recipe.serves;
    final note = recipe.notes;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(16),
        build: (pw.Context context) {
          return [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  recipe.title,
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: const PdfColor.fromInt(0xFF800000),
                  ),
                ),
                pw.SizedBox(height: 16),

                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTimeInfo('Cook time', cookTime),
                    _buildTimeInfo('Prep time', prepTime),
                    _buildTimeInfo('Total time', totalTime),
                  ],
                ),
                pw.SizedBox(height: 16),

                _buildSectionTitle('Ingredients'),
                pw.SizedBox(height: 8),
                ..._buildListItems(ingredients),

                pw.SizedBox(height: 16),
                _buildSectionTitle('Instructions'),
                pw.SizedBox(height: 8),
                ..._buildListItems(instructions),

                if (servedInstructions != "no") ...[
                  pw.SizedBox(height: 16),
                  _buildSectionTitle('Served Instructions'),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    servedInstructions,
                    style: const pw.TextStyle(fontSize: 14, color: PdfColors.black),
                  ),
                ],

                if (note != "no") ...[
                  pw.SizedBox(height: 16),
                  _buildSectionTitle('Notes'),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    note,
                    style: const pw.TextStyle(fontSize: 14, color: PdfColors.black),
                  ),
                ],
              ],
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }


  pw.Widget _buildSectionTitle(String title) {
    return pw.Text(
      "$title :",
      style: pw.TextStyle(
        fontSize: 18,
        fontWeight: pw.FontWeight.bold,
        color: const PdfColor.fromInt(0xFF800000),
      ),
    );
  }

  pw.Widget _buildTimeInfo(String label, String value) {
    return pw.Column(
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
            color: const PdfColor.fromInt(0xFF800000),
          ),
        ),
        pw.Text(
          value,
          style: const pw.TextStyle(fontSize: 12, color: PdfColors.black),
        ),
      ],
    );
  }

  List<pw.Widget> _buildListItems(List<String> items) {
    return items.map((item) {
      return pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 4),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("*  ", style:  pw.TextStyle(color: PdfColors.black,fontWeight: pw.FontWeight.bold,fontSize: 16 )),
            pw.Expanded(
              child: pw.Text(
                item.trim(),
                style: const pw.TextStyle(fontSize: 14, color: PdfColors.black),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }



  void _shareRecipe() {
    final recipe = widget.recipeModel;

    final recipeTimes = recipe.time;
    List<String> timeParts =
    recipeTimes.split(',').where((part) => part.trim().isNotEmpty).toList();


    final totalTime = timeParts.length > 2 ? timeParts[2].trim() : 'N/A';

    final ingredients = recipe.ingredients.split(',,');
    final instructions = recipe.instructions.split(',,');
    final servedInstructions = recipe.serves;
    final note = recipe.notes;

    String message = '''
🍽 **${recipe.title}** 🍽
────────────────────────────
🕒 **Cook Time**: $totalTime minutes

🍴 **Ingredients**:
$ingredients

👩‍🍳 **Instructions**:
$instructions
────────────────────────────
''';

    if (recipe.serves != "no") {
      message += '''
🍽 **Served Instructions**:
$servedInstructions
────────────────────────────
''';
    }

    if (recipe.notes != "no") {
      message += '''
📝 **Notes**:
$note
────────────────────────────
''';
    }

    message += '''
Enjoy your meal! 🍽✨
''';

    Share.share(message, subject: 'Check out this recipe!');
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipeModel;

    final recipeTimes = recipe.time;
    List<String> timeParts =
        recipeTimes.split(',').where((part) => part.trim().isNotEmpty).toList();

    final cookTime = timeParts.isNotEmpty ? timeParts[0].trim() : 'N/A';
    final prepTime = timeParts.length > 1 ? timeParts[1].trim() : 'N/A';
    final totalTime = timeParts.length > 2 ? timeParts[2].trim() : 'N/A';

    final ingredients = recipe.ingredients.split(',,');
    final instructions = recipe.instructions.split(',,');
    final servedInstructions = recipe.serves;
    final note = recipe.notes;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.white,
        title: const Text("Recipe Detail"),
        backgroundColor: FoodColors.mainColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.network(
                  recipe.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: FoodColors.secondaryColor.withOpacity(0.8),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(14),
                        topLeft: Radius.circular(14),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                      child: Text(
                        recipe.title,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildTimeInfo('Cook time', cookTime),
                        const SizedBox(width: 8,),
                        buildTimeInfo('Prep time', prepTime),
                        const SizedBox(width: 8,),
                        buildTimeInfo('Total time', totalTime),
                        const SizedBox(width: 8,),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                buildIngredientsCard(
                  ingredients,
                  icon: FoodAssets.ingredients,
                  title: 'Ingredients',
                  shape: BoxShape.rectangle,
                ),
                const SizedBox(height: 16),
                buildIngredientsCard(
                  instructions,
                  icon: FoodAssets.instruction,
                  title: 'Instructions',
                  shape: BoxShape.circle,
                ),
                const SizedBox(height: 16),
                if (servedInstructions != "no")
                  buildInfoCard(
                    'Served Instructions',
                    servedInstructions,
                    FoodAssets.served,
                  ),
                if (note != "no")
                  buildInfoCard(
                    'Note',
                    note,
                    FoodAssets.note,
                  ),
                const SizedBox(height: 80),
              ],
            ),

          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: FoodColors.mainColor,
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                final favoritesProvider = Provider.of<FavoritesProvider>(context, listen: false);
                final isFavorite = favoritesProvider.isFavorite(widget.recipeModel);

                if (isFavorite) {
                  favoritesProvider.removeFavorite(widget.recipeModel);
                } else {
                  favoritesProvider.addFavorite(widget.recipeModel);
                }
              },
              child: Consumer<FavoritesProvider>(
                builder: (context, favoritesProvider, child) {
                  final isFavorite = favoritesProvider.isFavorite(widget.recipeModel);

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        isFavorite ? FoodAssets.passion : FoodAssets.fav,
                        height: 24,
                        width: 24,
                        color: isFavorite
                            ? Colors.white
                            : Colors.white.withOpacity(0.6),
                      ),
                      Text(
                        'Favorite',
                        style: TextStyle(
                          fontSize: 12,
                          color: isFavorite
                              ? Colors.white
                              : Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                  _generateAndPreviewPDF();
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    FoodAssets.pdf,
                    height: 24,
                    width: 24,
                    color: _selectedIndex == 1
                        ? Colors.white
                        : Colors.white.withOpacity(0.6),
                  ),
                  Text(
                    'Export PDF',
                    style: TextStyle(
                      fontSize: 12,
                      color: _selectedIndex == 1
                          ? Colors.white
                          : Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                  _shareRecipe();
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    FoodAssets.share2,
                    height: 24,
                    width: 24,
                    color: _selectedIndex == 2
                        ? Colors.white
                        : Colors.white.withOpacity(0.6),
                  ),
                  Text(
                    'Share',
                    style: TextStyle(
                      fontSize: 12,
                      color: _selectedIndex == 2
                          ? Colors.white
                          : Colors.white.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoCard(String title, String content, String icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Colors.black.withOpacity(0.2),
            width: 1.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                icon,
                height: 25,
                width: 25,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: FoodColors.mainColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      content,
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTimeInfo(String title, String time) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black.withOpacity(0.2)),
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                "assets/icons/clock.png",
                height: 25,
                width: 25,
              ),
              const SizedBox(
                width: 3,
              ),
              Text(
                time,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 8,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: FoodColors.mainColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildIngredientsCard(List<String> ingredients,
      {required String icon, required String title, required BoxShape shape}) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        borderOnForeground: true,
        color: Colors.white,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Colors.black.withOpacity(0.2),
            width: 1.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    icon,
                    height: 24,
                    width: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: FoodColors.mainColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...ingredients.asMap().entries.map(
                (entry) {
                  int index = entry.key;
                  String ingredient = entry.value;

                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: shape,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              ingredient,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      if (index != ingredients.length - 1 &&
                          title == 'Ingredients')
                        const Divider(),
                      if (index != ingredients.length - 1)
                        const SizedBox(height: 12),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
