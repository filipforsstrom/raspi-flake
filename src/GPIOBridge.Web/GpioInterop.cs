using System.Runtime.InteropServices;
using System.Reflection;
using System.Text;
using Microsoft.Extensions.Configuration;

namespace web;

public static class GpioInterop
{
    private const string LibraryName = "gpio";
    private static string? _libraryPath;

    // Define path to the library from configuration
    static GpioInterop()
    {
        // Load configuration
        var configuration = new ConfigurationBuilder()
            .AddJsonFile("appsettings.json", optional: true)
            .AddJsonFile($"appsettings.{Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT") ?? "Production"}.json", optional: true)
            .Build();

        // Get library path from configuration
        _libraryPath = configuration["GpioLibrary:Path"];

        NativeLibrary.SetDllImportResolver(typeof(GpioInterop).Assembly, ImportResolver);
    }

    private static nint ImportResolver(string libraryName, Assembly assembly, DllImportSearchPath? searchPath)
    {
        if (libraryName == LibraryName && !string.IsNullOrEmpty(_libraryPath))
        {
            try
            {
                return NativeLibrary.Load(_libraryPath);
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine($"Failed to load library from {_libraryPath}: {ex.Message}");
            }
        }

        return nint.Zero;
    }

    [DllImport(LibraryName)]
    public static extern int gpio_hello();

    [DllImport(LibraryName)]
    public static extern int gpio_get_chip_info(
        [MarshalAs(UnmanagedType.LPStr)] StringBuilder labelBuffer,
        int labelSize,
        [MarshalAs(UnmanagedType.LPStr)] StringBuilder nameBuffer,
        int nameSize,
        out uint lines);
}