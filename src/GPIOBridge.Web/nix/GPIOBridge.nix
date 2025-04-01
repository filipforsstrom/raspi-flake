{
  buildDotnetModule,
  dotnetCorePackages,
}:
buildDotnetModule {
  pname = "GPIOBridge";
  version = "0.1.0";

  src = ../.;

  projectFile = "GPIOBridge.Web.csproj";
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_9_0;

  # The name of the executable that will be generated
  executables = ["GPIOBridge.Web"];
}
