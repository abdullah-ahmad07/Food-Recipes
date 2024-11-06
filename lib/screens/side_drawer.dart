import 'package:flutter/material.dart';
import 'package:food_recipes/consts/app_colors.dart';
import 'package:food_recipes/screens/favorite_recipe.dart';
import 'package:share_plus/share_plus.dart';

import '../consts/assets.dart';

class SideDrawer extends StatefulWidget {
  const SideDrawer({super.key});

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {

  void shareApp() {
    const appLink = 'https://play.google.com/store/apps/details?id=com.foodrecipes.pizzarecipes.cakerecipes.chickenrecipes.audiorecipes.food_recipes';
    Share.share('Check out this amazing app: $appLink');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/icons/drawer_image.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: null,
          ),
          ListTile(
            leading:  Image.asset(FoodAssets.passion,color: Colors.black,height: 20,width: 20,),
            title: const Text('My Favorites Recipes'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context)=> const FavoriteRecipesScreen())
              );
            },
          ),
          ListTile(
            leading: Image.asset(FoodAssets.share,height: 20,width: 20,),
            title: const Text('Share App'),
            onTap: shareApp,
          ),
          ListTile(
            leading: Image.asset("assets/icons/smartphone.png",height: 20,width: 20,),
            title: RichText(
              text:  TextSpan(
                children: [
                  const TextSpan(
                    text: 'App Version ',
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    text: '(1.0.0)',
                    style: TextStyle(color: FoodColors.mainColor,fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

