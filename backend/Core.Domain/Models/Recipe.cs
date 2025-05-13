namespace Core.Domain.Models
{
    public class Recipe
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Image { get; set; }
        public List<string> Ingredients { get; set; } = new();
    }
}