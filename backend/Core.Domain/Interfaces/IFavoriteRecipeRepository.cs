using Core.Domain.Entities;

namespace Core.Domain.Interfaces
{
    public interface IFavoriteRecipeRepository
    {
        Task<IEnumerable<FavoriteRecipe>> GetAllAsync();
        Task<FavoriteRecipe?> GetByIdAsync(Guid id);
        Task AddAsync(FavoriteRecipe recipe);
        Task DeleteAsync(Guid id);
        Task SaveChangesAsync();
    }
}
