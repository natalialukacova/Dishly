using System;

namespace Core.Domain.Entities
{
    public class FavoriteRecipe
    {
        public Guid Id { get; set; }
        public string RecipeId { get; set; }
        public string Title { get; set; }
        public string Source { get; set; }  // "external" or "ai"
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}