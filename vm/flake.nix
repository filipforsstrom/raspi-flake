{
  description = "Development environment and Deployment for dotnet API";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};

      testVm = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs.inputs = inputs;
        modules = [
          {
            virtualisation.vmVariant = {
              # following configuration is added only when building VM with build-vm
              virtualisation = {
                memorySize = 2048; # Use 2048MiB memory.
                cores = 3;
                graphics = false;
              };
            };

            # user
            services.getty.autologinUser = "root";
            users.users.root.initialPassword = "root";
            system.stateVersion = "24.11";
          }
        ];
      };
    in {
      apps.default = {
        type = "app";
        program = "${testVm.config.system.build.vm}/bin/run-nixos-vm";
      };

      devShell = pkgs.mkShell {
        packages = with pkgs; [
          dotnetCorePackages.sdk_9_0_1xx
          nuget-to-json
        ];
        shellHook = ''
          export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1 #workaround for c# dev kit
        '';
      };
    });
}
