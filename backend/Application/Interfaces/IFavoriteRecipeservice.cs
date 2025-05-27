using Core.Domain.Entities;
using Core.Domain.Models;

namespace Application.Interfaces;

public interface IFavoriteRecipeService
{
    Task<IEnumerable<FavoriteRecipe>> GetAllAsync();
    Task<FavoriteRecipe?> GetByIdAsync(Guid id);
    Task AddAsync(FavoriteRecipe recipe);
    Task DeleteAsync(Guid id);
    Task<List<Recipe>> GetDetailedFavoritesAsync();
}