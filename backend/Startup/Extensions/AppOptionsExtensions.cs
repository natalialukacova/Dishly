using Application.Models;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace Startup.Extensions;

public static class AppOptionsExtensions
{
    public static AppOptions AddAppOptions(this IServiceCollection services, IConfiguration configuration)
    {
        var section = configuration.GetSection("AppOptions");
        services.Configure<AppOptions>(section);
        return section.Get<AppOptions>()!;
    }
}