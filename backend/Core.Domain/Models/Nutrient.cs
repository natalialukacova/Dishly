namespace Core.Domain.Models
{
    public class Nutrient
    {
        public required string Name { get; set; }
        public double Amount { get; set; }
        public required string Unit { get; set; }
    }
}