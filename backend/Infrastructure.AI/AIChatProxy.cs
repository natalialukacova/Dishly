using Application.Interfaces;
using System.Net.Http;
using System.Net.Http.Json;

namespace Infrastructure.AI
{
    public class AIChatProxy : IAIChatProxy
    {
        private readonly HttpClient _httpClient;

        public AIChatProxy(HttpClient httpClient)
        {
            _httpClient = httpClient;
        }

        public async Task<string> SendToPythonAsync(string recipeId, string message)
        {
            var payload = new
            {
                recipe_id = recipeId,
                message = message
            };

            var response = await _httpClient.PostAsJsonAsync("http://localhost:8000/chat", payload);

            if (!response.IsSuccessStatusCode)
            {
                Console.WriteLine($"Error: {response.StatusCode}");
                return "Sorry, I couldn't process your request.";
            }

            var result = await response.Content.ReadFromJsonAsync<ChatResponse>();
            return result?.Response ?? "No reply.";
        }

        private class ChatResponse
        {
            public required string Response { get; set; }
        }
    }
}