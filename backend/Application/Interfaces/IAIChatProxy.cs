namespace Application.Interfaces;

public interface IAIChatProxy
{
    Task<string> SendToPythonAsync(string recipeId, string message);
}
