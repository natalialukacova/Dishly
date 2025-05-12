namespace API.WebSocket;

using Application.AI.Interfaces;
using Newtonsoft.Json;

public class WebSocketConnectionHandler
{
    private readonly IWebSocketConnection _socket;
    private readonly IAIChatProxy _aiChatProxy;

    public WebSocketConnectionHandler(IWebSocketConnection socket, IAIChatProxy aiChatProxy)
    {
        _socket = socket;
        _aiChatProxy = aiChatProxy;
    }

    public async Task HandleMessage(string json)
    {
        var data = JsonConvert.DeserializeObject<ChatMessage>(json);
        var responseText = await _aiChatProxy.SendToPythonAsync(data.RecipeId, data.Message);

        var response = new
        {
            recipeId = data.RecipeId,
            message = responseText
        };

        await _socket.Send(JsonConvert.SerializeObject(response));
    }

    private class ChatMessage
    {
        public string RecipeId { get; set; }
        public string Message { get; set; }
    }
}

