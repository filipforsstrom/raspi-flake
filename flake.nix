{
  description = "Raspberry Pi 4 vm, sd card image and deploy";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.disko = {
    url = "github:nix-community/disko";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.impermanence.url = "github:nix-community/impermanence";
  inputs.deploy-rs.url = "github:serokell/deploy-rs";
  inputs.nixos-generators = {
    url = "github:nix-community/nixos-generators";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    deploy-rs,
    flake-utils,
    nixos-generators,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};

      testVm = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs.inputs = inputs;
        modules = [
          ./nix/state-version.nix
          ./nix/qemu.nix
          ./nix/configuration.nix
        ];
      };
    in {
      apps.default = {
        type = "app";
        program = "${testVm.config.system.build.vm}/bin/run-raspi-nix-vm";
      };

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
    })
    // {
      packages.x86_64-linux = {
        sdcard = nixos-generators.nixosGenerate {
          system = "aarch64-linux";
          format = "sd-aarch64";
          modules = [
            ./nix/state-version.nix
            ./nix/sd/hardware-configuration.nix
            ./nix/sd/configuration.nix
            {
              sdImage.compressImage = false;
            }
          ];
        };
      };

      nixosConfigurations = {
        raspi-nix = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            inputs.disko.nixosModules.disko
            inputs.impermanence.nixosModules.impermanence
            ./nix/state-version.nix
            ./nix/configuration.nix
            # ./nix/impermanence.nix
            ./nix/hardware-configuration.nix
            # ./nix/disk.nix
            ./nix/vscode-server.nix
          ];
        };
      };
      deploy.nodes.raspi-nix = {
        hostname = "raspi-nix";
        profiles.system = {
          user = "root";
          path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.raspi-nix;
        };
      };

      # This is highly advised, and will prevent many possible mistakes
      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
