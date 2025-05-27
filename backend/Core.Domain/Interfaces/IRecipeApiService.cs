using System.Collections.Generic;
using System.Threading.Tasks;
using Core.Domain.Models;

namespace Core.Domain.Interfaces;

public interface IRecipeApiService
{
    Task<List<Recipe>> SearchRecipesByIngredientsAsync(string ingredients);
    Task<Recipe?> FetchByIdAsync(int id);
}
