using Infrastructure.Database;
using Microsoft.EntityFrameworkCore;
using Core.Domain.Interfaces;
using Infrastructure.Repositories;
using Application.Interfaces;
using Application.Services;

var builder = WebApplication.CreateBuilder(args);
var configuration = builder.Configuration;


// Database
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseNpgsql(configuration.GetConnectionString("DefaultConnection")));

// Dependency Injection
builder.Services.AddScoped<IFavoriteRecipeRepository, FavoriteRecipeRepository>();
builder.Services.AddScoped<IFavoriteRecipeService, FavoriteRecipeService>();

// Add Controllers
builder.Services.AddControllers();

var app = builder.Build();

// Run migrations
using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    db.Database.Migrate();
}


app.UseRouting();
app.MapControllers();            

app.Run();