using System;
using System.Threading;
using System.Threading.Tasks;
using Fleck;
using Microsoft.Extensions.Hosting;

namespace Infrastructure.WebSocket;

public class WebSocketServerService : BackgroundService
{
    private WebSocketServer? _server;

    protected override Task ExecuteAsync(CancellationToken stoppingToken)
    {
        _server = new WebSocketServer("ws://0.0.0.0:8181");
        _server.Start(socket =>
        {
            socket.OnOpen = () => Console.WriteLine("Client connected!");
            socket.OnClose = () => Console.WriteLine("Client disconnected.");
            socket.OnMessage = async message =>
            {
                Console.WriteLine("Received: " + message);
                var aiResponse = $"Echo: {message}";
                socket.Send(aiResponse);
            };
        });

        Console.WriteLine("WebSocket server started on ws://0.0.0.0:8181");
        return Task.CompletedTask;
    }

    public override Task StopAsync(CancellationToken cancellationToken)
    {
        Console.WriteLine("WebSocket server is stopping...");
        return base.StopAsync(cancellationToken);
    }
}