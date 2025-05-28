using Microsoft.Extensions.DependencyInjection;
using Application.Models;
using Application.Interfaces;
using Core.Domain.Interfaces;
using Infrastructure.AI;
using Infrastructure.ExternalApi;

namespace Startup.Extensions;

public static class ServiceCollectionExtensions
{
    public static IServiceCollection AddRestApi(this IServiceCollection services)
    {
        services.AddControllers();
        return services;
    }

    public static IServiceCollection ConfigureAppServices(this IServiceCollection services, IConfiguration configuration)
    {
        services.Configure<AppOptions>(configuration);

        services.AddHttpClient<IRecipeApiService, RecipeApiService>();
        services.AddHttpClient<IAIChatProxy, AIChatProxy>();
        
        return services;
    }
}