using Infrastructure.Database;
using Microsoft.EntityFrameworkCore;
using Core.Domain.Interfaces;
using Infrastructure.Repositories;
using Application.Interfaces;
using Application.Services;
using Infrastructure.WebSocket; 
using Infrastructure.AI;
using Infrastructure.ExternalApi;
using Startup.Extensions;
using Application.Models;

var builder = WebApplication.CreateBuilder(args);
builder.WebHost.UseUrls("http://0.0.0.0:5000");
var configuration = builder.Configuration;

builder.Services.AddAppOptions(builder.Configuration);
builder.Services.ConfigureAppServices(builder.Configuration);

builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseNpgsql(configuration.GetConnectionString("DefaultConnection")));

// Dependency Injection
builder.Services.AddScoped<IFavoriteRecipeRepository, FavoriteRecipeRepository>();
builder.Services.AddScoped<IFavoriteRecipeService, FavoriteRecipeService>();
builder.Services.AddScoped<IRecipeApiService, RecipeApiService>();

builder.Services.AddHostedService<WebSocketServerService>();
builder.Services.AddHttpClient<IAIChatProxy, AIChatProxy>();

builder.Services.AddHttpClient();
builder.Services.AddRestApi(); 
builder.Services.AddWebsocketInfrastructure(); 

var app = builder.Build();


app.MigrateDatabase(); 

if (app.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage(); 
}

app.UseRouting();
app.ConfigureRestApi();        
app.ConfigureWebsocketApi();    
app.StartProxyServer();         

app.Run();