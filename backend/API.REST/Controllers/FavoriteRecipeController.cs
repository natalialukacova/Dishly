using Application.Interfaces;
using Core.Domain.Entities;
using Microsoft.AspNetCore.Mvc;

namespace API.REST.Controllers;

[ApiController]
[Route("api/[controller]")]
public class FavoriteRecipeController : ControllerBase
{
    private readonly IFavoriteRecipeService _service;

    public FavoriteRecipeController(IFavoriteRecipeService service)
    {
        _service = service;
    }

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var recipes = await _service.GetAllAsync();
        return Ok(recipes);
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> GetById(Guid id)
    {
        var recipe = await _service.GetByIdAsync(id);
        if (recipe == null)
            return NotFound();

        return Ok(recipe);
    }

    [HttpPost]
    public async Task<IActionResult> Add([FromBody] FavoriteRecipe recipe)
    {
        await _service.AddAsync(recipe);
        return CreatedAtAction(nameof(GetById), new { id = recipe.Id }, recipe);
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(Guid id)
    {
        var recipe = await _service.GetByIdAsync(id);
        if (recipe == null)
            return NotFound();

        await _service.DeleteAsync(id);
        return NoContent();
    }

	[HttpGet("recipes")]
	public async Task<IActionResult> GetDetailedFavorites()
	{
    	var recipes = await _service.GetDetailedFavoritesAsync();
    	return Ok(recipes);
	}
}