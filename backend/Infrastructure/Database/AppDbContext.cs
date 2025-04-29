using Microsoft.EntityFrameworkCore;
using Core.Domain.Entities;

namespace Infrastructure.Database;


public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options)
        : base(options) {}

    public DbSet<FavoriteRecipe> FavoriteRecipes { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
    }
}