using System.Net.Http;
using System.Net.Http.Json;
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
        var encodedIngredients = Uri.EscapeDataString(ingredients);
        var url = $"https://api.spoonacular.com/recipes/findByIngredients?ingredients={encodedIngredients}&number=5&apiKey={_options.ApiKey}";
        var response = await _httpClient.GetAsync(url);

        if (!response.IsSuccessStatusCode)
            throw new Exception("Failed to fetch recipes");

        var json = await response.Content.ReadAsStringAsync();
        var summaryList = JsonSerializer.Deserialize<List<RecipeSummary>>(json, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });

        var detailedRecipes = new List<Recipe>();

        foreach (var summary in summaryList ?? new List<RecipeSummary>())
        {
            var recipe = await FetchByIdAsync(summary.Id);
            if (recipe != null)
            {
                detailedRecipes.Add(recipe);

                // Build readable recipe text
                var ingredientsText = string.Join(", ", recipe.Ingredients);
                var instructionsText = recipe.Instructions;
                var recipeText = $"Ingredients: {ingredientsText}\nInstructions: {instructionsText}";

                var storePayload = new
                {
                    recipe_id = recipe.Id,
                    recipe_text = recipeText
                };

                try
                {
                    var storeResponse = await _httpClient.PostAsJsonAsync("http://localhost:8000/store_recipe", storePayload);
                    if (storeResponse.IsSuccessStatusCode)
                        Console.WriteLine($"[C#] Stored recipe {recipe.Id} in Python backend.");
                    else
                        Console.WriteLine($"[C#] Failed to store recipe {recipe.Id}. Status: {storeResponse.StatusCode}");
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"[C#] Exception while storing recipe: {ex.Message}");
                }
            }
        }

        return detailedRecipes;
    }

    public async Task<Recipe?> FetchByIdAsync(int id)
    {
        var url = $"https://api.spoonacular.com/recipes/{id}/information?includeNutrition=true&apiKey={_options.ApiKey}";
        return await FetchByUrlAsync(url);
    }

    public async Task<Recipe?> FetchByUrlAsync(string url)
    {
        var response = await _httpClient.GetAsync(url);
        if (!response.IsSuccessStatusCode) return null;

        var json = await response.Content.ReadAsStringAsync();
        var jsonDoc = JsonSerializer.Deserialize<JsonElement>(json);

        return new Recipe
        {
            Id = jsonDoc.GetProperty("id").GetInt32(),
            Title = jsonDoc.GetProperty("title").GetString() ?? "",
            Image = jsonDoc.GetProperty("image").GetString() ?? "",
            Instructions = jsonDoc.GetProperty("instructions").GetString() ?? "",
            ReadyInMinutes = jsonDoc.GetProperty("readyInMinutes").GetInt32(),
            Servings = jsonDoc.GetProperty("servings").GetInt32(),
            Vegetarian = jsonDoc.GetProperty("vegetarian").GetBoolean(),
            Vegan = jsonDoc.GetProperty("vegan").GetBoolean(),
            GlutenFree = jsonDoc.GetProperty("glutenFree").GetBoolean(),
            Ingredients = jsonDoc.TryGetProperty("extendedIngredients", out var ings)
                ? ings.EnumerateArray().Select(i => i.GetProperty("original").GetString() ?? "").ToList()
                : new List<string>(),
            Nutrients = jsonDoc.TryGetProperty("nutrition", out var nutrition) &&
                        nutrition.TryGetProperty("nutrients", out var nutrients)
                ? nutrients.EnumerateArray().Select(n => new Nutrient
                {
                    Name = n.GetProperty("name").GetString() ?? "",
                    Amount = n.GetProperty("amount").GetDouble(),
                    Unit = n.GetProperty("unit").GetString() ?? ""
                }).ToList()
                : new List<Nutrient>()
        };
    }

    private class RecipeSummary
    {
        public int Id { get; set; }
    }
}