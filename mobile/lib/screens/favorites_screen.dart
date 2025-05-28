import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../main.dart';
import '../models/recipe.dart';
import '../screens/recipe_detail_screen.dart';
import '../services/favorites_service.dart';
import '../widgets/recipe_card.dart';

class FavoriteRecipesScreen extends StatefulWidget {
  const FavoriteRecipesScreen({super.key});

  @override
  State<FavoriteRecipesScreen> createState() => _FavoriteRecipesScreenState();
}

class _FavoriteRecipesScreenState extends State<FavoriteRecipesScreen> with RouteAware {
  List<Recipe> _recipes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _loadFavorites(); // reload data when returning to this screen
  }

  Future<void> _loadFavorites() async {
    setState(() => _isLoading = true);
    try {
      final favorites = await FavoriteRecipeService.getAllFavorites();
      setState(() {
        _recipes = favorites;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Failed to load favorites: $e");
      setState(() => _isLoading = false);
    }
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_recipes.isEmpty) {
      return const Center(child: Text("You haven't saved any recipes yet."));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _recipes.length,
      itemBuilder: (context, index) {
        final recipe = _recipes[index];
        return GestureDetector(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RecipeDetailScreen(recipe: recipe),
              ),
            );
          },
          child: RecipeCard(recipe: recipe),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("My Favorite Recipes"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _buildBody(),
    );
  }
}