using Microsoft.Extensions.DependencyInjection;

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
        // Add additional configuration or DI here if needed
        return services;
    }
}