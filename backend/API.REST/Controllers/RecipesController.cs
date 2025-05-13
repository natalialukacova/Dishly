using Core.Domain.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace API.REST.Controllers;

[ApiController]
[Route("api/recipes")]
public class RecipesController : ControllerBase
{
    private readonly IRecipeApiService _recipeService;

    public RecipesController(IRecipeApiService recipeService)
    {
        _recipeService = recipeService;
    }

    [HttpGet("search")]
public async Task<IActionResult> Search([FromQuery] string ingredients)
{
    var result = await _recipeService.SearchRecipesByIngredientsAsync(ingredients);
    return Ok(result);
}
}