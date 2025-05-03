using Core.Domain.Entities;
using Core.Domain.Interfaces;
using Infrastructure.Database;
using Microsoft.EntityFrameworkCore;

namespace Infrastructure.Repositories;

public class FavoriteRecipeRepository : IFavoriteRecipeRepository
{
    private readonly AppDbContext _context;

    public FavoriteRecipeRepository(AppDbContext context)
    {
        _context = context;
    }

    public async Task<IEnumerable<FavoriteRecipe>> GetAllAsync()
    {
        return await _context.FavoriteRecipes.ToListAsync();
    }

    public async Task<FavoriteRecipe?> GetByIdAsync(Guid id)
    {
        return await _context.FavoriteRecipes.FindAsync(id);
    }

    public async Task AddAsync(FavoriteRecipe recipe)
    {
        await _context.FavoriteRecipes.AddAsync(recipe);
    }

    public async Task DeleteAsync(Guid id)
    {
        var recipe = await _context.FavoriteRecipes.FindAsync(id);
        if (recipe != null)
            _context.FavoriteRecipes.Remove(recipe);
    }

    public async Task SaveChangesAsync()
    {
        await _context.SaveChangesAsync();
    }
}