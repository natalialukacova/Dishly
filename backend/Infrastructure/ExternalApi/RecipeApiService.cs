using System.Net.Http;
using System.Text.Json;
using System.Threading.Tasks;
using Core.Domain.Interfaces;
using Application.Models;
using Core.Domain.Models;
using Microsoft.Extensions.Options;

namespace Infrastructure.ExternalApi;

public class RecipeApiService : IRecipeApiService
{
    private readonly HttpClient _httpClient;
    private readonly SpoonacularOptions _options;

    public RecipeApiService(HttpClient httpClient, IOptions<AppOptions> config)
    {
        _httpClient = httpClient;
        _options = config.Value.Spoonacular;
    }

    public async Task<List<Recipe>> SearchRecipesByIngredientsAsync(string ingredients)
    {
        var url = $"https://api.spoonacular.com/recipes/findByIngredients?ingredients={ingredients}&number=5&apiKey={_options.ApiKey}";
        var response = await _httpClient.GetAsync(url);

        if (!response.IsSuccessStatusCode)
            throw new Exception("Failed to fetch recipes");

        var json = await response.Content.ReadAsStringAsync();
        var recipes = JsonSerializer.Deserialize<List<Recipe>>(json, new JsonSerializerOptions
        {
            PropertyNameCaseInsensitive = true
        });

        return recipes ?? new List<Recipe>();
    }
}