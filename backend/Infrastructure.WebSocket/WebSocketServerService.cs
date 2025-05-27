using System;
using System.Threading;
using System.Threading.Tasks;
using Fleck;
using Microsoft.Extensions.Hosting;
using Application.Models;
using Application.Interfaces;
using Newtonsoft.Json;

namespace Infrastructure.WebSocket;

public class WebSocketServerService : BackgroundService
{
    private WebSocketServer? _server;
    private readonly IAIChatProxy _chatProxy;
    
    public WebSocketServerService(IAIChatProxy chatProxy)
    {
        _chatProxy = chatProxy;
    }


    protected override Task ExecuteAsync(CancellationToken stoppingToken)
    {
        _server = new WebSocketServer("ws://0.0.0.0:8181");
        _server.Start(socket =>
        {
            socket.OnOpen = () =>
            {
                Console.WriteLine($"[Fleck] Connection opened: {socket.ConnectionInfo.ClientIpAddress}");
            };

            socket.OnClose = () =>
            {
                Console.WriteLine($"[Fleck] Connection closed");
            };
            
            socket.OnMessage = async message =>
            {
                Console.WriteLine("[C#] Received message from client: " + message);
            
                try
                {
                    var data = JsonConvert.DeserializeObject<ChatWebSocketMessage>(message);
                    var aiResponse = await _chatProxy.SendToPythonAsync(data.RecipeId, data.Message);
                    Console.WriteLine("[C#] AI response from Python: " + aiResponse);
                    
                    var response = new
                    {
                        recipeId = data.RecipeId,
                        message = aiResponse
                    };

                    var jsonResponse = JsonConvert.SerializeObject(response);
                    await socket.Send(jsonResponse);
                }
                catch (Exception ex)
                {
                    Console.WriteLine("[C#] Error: " + ex.Message);
                    await socket.Send(JsonConvert.SerializeObject(new
                    {
                        error = "Invalid message or internal server error"
                    }));
                }
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