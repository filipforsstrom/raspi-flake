using System.Runtime.InteropServices;
using System.Reflection;
using System.Text;

namespace web;

public static class GpioInterop
{
    private const string LibraryName = "gpio";

    // Define path to the library (adjust path as needed)
    static GpioInterop()
    {
        NativeLibrary.SetDllImportResolver(typeof(GpioInterop).Assembly, ImportResolver);
    }

    private static nint ImportResolver(string libraryName, Assembly assembly, DllImportSearchPath? searchPath)
    {
        if (libraryName == LibraryName)
        {
            // Adjust path as needed
            return NativeLibrary.Load("../gpio/lib/libgpio.so");
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