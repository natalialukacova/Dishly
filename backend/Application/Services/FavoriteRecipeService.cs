using Application.Interfaces;
using Core.Domain.Entities;
using Core.Domain.Interfaces;

namespace Application.Services;

public class FavoriteRecipeService : IFavoriteRecipeService
{
    private readonly IFavoriteRecipeRepository _repository;

    public FavoriteRecipeService(IFavoriteRecipeRepository repository)
    {
        _repository = repository;
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
}