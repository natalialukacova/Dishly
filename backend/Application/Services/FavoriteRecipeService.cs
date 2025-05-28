using Application.Interfaces;
using Core.Domain.Entities;
using Core.Domain.Interfaces;
using Core.Domain.Models;

namespace Application.Services;

public class FavoriteRecipeService : IFavoriteRecipeService
{
    private readonly IFavoriteRecipeRepository _repository;
    private readonly IRecipeApiService _recipeApiService;

    public FavoriteRecipeService(
        IFavoriteRecipeRepository repository,
        IRecipeApiService recipeApiService)
    {
        _repository = repository;
        _recipeApiService = recipeApiService;
    }

    public async Task<IEnumerable<FavoriteRecipe>> GetAllAsync()
    {
        return await _repository.GetAllAsync();
    }

    public async Task<FavoriteRecipe?> GetByIdAsync(Guid id)
    {
        return await _repository.GetByIdAsync(id);
    }

    public async Task AddAsync(FavoriteRecipe recipe)
    {
        await _repository.AddAsync(recipe);
        await _repository.SaveChangesAsync();
    }

    public async Task DeleteAsync(Guid id)
    {
        await _repository.DeleteAsync(id);
        await _repository.SaveChangesAsync();
    }

    public async Task<List<Recipe>> GetDetailedFavoritesAsync()
    {
        var favorites = await _repository.GetAllAsync();
        var fullRecipes = new List<Recipe>();

        foreach (var fav in favorites)
        {
            try
            {
                var recipe = await _recipeApiService.FetchByIdAsync(int.Parse(fav.RecipeId));
                if (recipe != null)
                    fullRecipes.Add(recipe);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[FavoriteRecipeService] Failed to fetch recipe ID {fav.RecipeId}: {ex.Message}");
            }
        }

        return fullRecipes;
    }
}