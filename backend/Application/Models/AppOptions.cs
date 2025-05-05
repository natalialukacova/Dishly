namespace Application.Models;

public class AppOptions
{
    public int PORT { get; set; } = 5000;
    public int REST_PORT { get; set; } = 5000;
    public int WS_PORT { get; set; } = 8181;
    public bool Seed { get; set; } = false;
}