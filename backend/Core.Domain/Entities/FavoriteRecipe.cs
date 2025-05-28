using System;

namespace Core.Domain.Entities
{
    public class FavoriteRecipe
    {
        public Guid Id { get; set; }
        public required string RecipeId { get; set; }
        public required string Title { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}