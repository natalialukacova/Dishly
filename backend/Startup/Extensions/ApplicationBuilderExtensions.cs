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

    public static WebApplication MigrateDatabase(this WebApplication app)
    {
        using var scope = app.Services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
        db.Database.Migrate();
        return app;
    }
}