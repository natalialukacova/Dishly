using Core.Domain.Entities;

namespace Application.Interfaces;

public interface IFavoriteRecipeService
{
    Task<IEnumerable<FavoriteRecipe>> GetAllAsync();
    Task<FavoriteRecipe?> GetByIdAsync(Guid id);
    Task AddAsync(FavoriteRecipe recipe);
    Task DeleteAsync(Guid id);
}