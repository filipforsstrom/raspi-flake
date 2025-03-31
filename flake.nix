{
  description = "dotnet environment";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

  outputs = {
    self,
    flake-utils,
    nixpkgs,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShell = pkgs.mkShell {
          packages = with pkgs; [
            dotnetCorePackages.sdk_9_0
            nuget-to-nix
            gcc
          ];
          shellHook = ''
            export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1 #workaround for c# dev kit
          '';
        };
      }
    );
}
