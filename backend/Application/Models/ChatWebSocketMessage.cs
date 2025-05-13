namespace Application.Models
{
    public class ChatWebSocketMessage
    {
        public required string RecipeId { get; set; }
        public required string Message { get; set; }
    }
}