using System.Text;
using GPIOBridge.Web;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddOpenApi();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseHttpsRedirection();

app.MapGet("/gpio/hello", () =>
{
    int result = GpioInterop.gpio_hello();
    return new { Message = "GPIO Hello returned", Value = result };
})
.WithName("GetGpioHello");

app.MapGet("/gpio/info", () =>
{
    StringBuilder labelBuffer = new StringBuilder(32);
    StringBuilder nameBuffer = new StringBuilder(32);
    uint lines = 0;

    int result = GpioInterop.gpio_get_chip_info(labelBuffer, labelBuffer.Capacity,
        nameBuffer, nameBuffer.Capacity, out lines);

    if (result < 0)
    {
        return Results.Problem("Failed to get GPIO chip info");
    }

    return Results.Ok(new
    {
        Label = labelBuffer.ToString(),
        Name = nameBuffer.ToString(),
        Lines = lines
    });
})
.WithName("GetGpioInfo");

app.Run();
