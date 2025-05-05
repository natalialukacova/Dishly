using Microsoft.Extensions.DependencyInjection;

namespace Infrastructure.WebSocket
{
    public static class ServiceCollectionExtensions
    {
        public static IServiceCollection AddWebsocketInfrastructure(this IServiceCollection services)
        {
            services.AddHostedService<WebSocketServerService>();
            return services;
        }
    }
}