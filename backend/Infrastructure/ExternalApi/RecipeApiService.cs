using System.Net.Http;
using System.Text.Json;
using System.Threading.Tasks;
using Core.Domain.Interfaces;
using Application.Models;
using Core.Domain.Models;
using Microsoft.Extensions.Options;
using System.Collections.Generic;

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
        var summaryList = JsonSerializer.Deserialize<List<RecipeSummary>>(json, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });

        var detailedRecipes = new List<Recipe>();

        foreach (var summary in summaryList ?? new List<RecipeSummary>())
        {
            var infoUrl = $"https://api.spoonacular.com/recipes/{summary.Id}/information?includeNutrition=true&apiKey={_options.ApiKey}";
            var infoResponse = await _httpClient.GetAsync(infoUrl);
            if (!infoResponse.IsSuccessStatusCode)
                continue;

            var detailJson = await infoResponse.Content.ReadAsStringAsync();
            var detailed = JsonSerializer.Deserialize<JsonElement>(detailJson);

            var recipe = new Recipe
            {
                Id = detailed.GetProperty("id").GetInt32(),
                Title = detailed.GetProperty("title").GetString() ?? "",
                Image = detailed.GetProperty("image").GetString() ?? "",
                Instructions = detailed.GetProperty("instructions").GetString() ?? "",
                ReadyInMinutes = detailed.GetProperty("readyInMinutes").GetInt32(),
                Servings = detailed.GetProperty("servings").GetInt32(),
                Vegetarian = detailed.GetProperty("vegetarian").GetBoolean(),
                Vegan = detailed.GetProperty("vegan").GetBoolean(),
                GlutenFree = detailed.GetProperty("glutenFree").GetBoolean(),
                Ingredients = detailed.TryGetProperty("extendedIngredients", out var ings)
                    ? ings.EnumerateArray().Select(i => i.GetProperty("original").GetString() ?? "").ToList()
                    : new List<string>(),
                Nutrients = detailed.TryGetProperty("nutrition", out var nutrition) &&
                            nutrition.TryGetProperty("nutrients", out var nutrients)
                    ? nutrients.EnumerateArray().Select(n => new Nutrient
                    {
                        Name = n.GetProperty("name").GetString() ?? "",
                        Amount = n.GetProperty("amount").GetDouble(),
                        Unit = n.GetProperty("unit").GetString() ?? ""
                    }).ToList()
                    : new List<Nutrient>()
            };

            detailedRecipes.Add(recipe);
        }

        return detailedRecipes;
    }

    private class RecipeSummary
    {
        public int Id { get; set; }
    }
}