using Infrastructure.Database;
using Microsoft.AspNetCore.Builder;
using Microsoft.EntityFrameworkCore;

namespace Startup.Extensions;

public static class ApplicationBuilderExtensions
{
    public static WebApplication ConfigureRestApi(this WebApplication app)
    {
        app.MapControllers();
        return app;
    }

    public static WebApplication ConfigureWebsocketApi(this WebApplication app)
    {
        // In the future, you can add WebSocket-specific routes or middleware here
        return app;
    }

    public static WebApplication StartProxyServer(this WebApplication app)
    {
        // Optional: implement later if you're acting as a reverse proxy to Python etc.
        return app;
    }

    public static WebApplication MigrateDatabase(this WebApplication app)
    {
        using var scope = app.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
        db.Database.Migrate();
        return app;
    }
}