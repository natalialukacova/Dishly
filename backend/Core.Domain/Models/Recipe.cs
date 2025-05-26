namespace Core.Domain.Models
{
    public class Recipe
    {
        public int Id { get; set; }
        public string Title { get; set; } = "";
        public string Image { get; set; } = "";
        public string Instructions { get; set; } = "";
        public int ReadyInMinutes { get; set; }
        public int Servings { get; set; }
        public List<string> Ingredients { get; set; } = new();
        public List<Nutrient> Nutrients { get; set; } = new();
        public bool Vegetarian { get; set; }
        public bool Vegan { get; set; }
        public bool GlutenFree { get; set; }
    }

}