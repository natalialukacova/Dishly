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
            socket.OnOpen = () => Console.WriteLine("Client connected!");
            socket.OnClose = () => Console.WriteLine("Client disconnected.");
            
            socket.OnMessage = async message =>
            {
                Console.WriteLine("Received message: " + message);

                try
                {
                    var data = JsonConvert.DeserializeObject<ChatWebSocketMessage>(message);
                    var aiResponse = await _chatProxy.SendToPythonAsync(data.RecipeId, data.Message);

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
                    Console.WriteLine("Error handling message: " + ex.Message);
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