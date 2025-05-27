using System;

namespace Core.Domain.Entities
{
    public class FavoriteRecipe
    {
        public Guid Id { get; set; }
        public string RecipeId { get; set; }
        public string Title { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}