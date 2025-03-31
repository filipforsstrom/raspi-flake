{
  description = "Development environment and Deployment for dotnet API";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.disko = {
    url = "github:nix-community/disko";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.impermanence.url = "github:nix-community/impermanence";
  inputs.deploy-rs.url = "github:serokell/deploy-rs";

  outputs = {
    self,
    nixpkgs,
    deploy-rs,
    flake-utils,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};

      testVm = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs.inputs = inputs;
        modules = [
          ./qemu.nix
          ./configuration.nix
        ];
      };
    in {
      apps.default = {
        type = "app";
        program = "${testVm.config.system.build.vm}/bin/run-raspi-nix-vm";
      };
    })
    // {
      nixosConfigurations = {
        raspi-nix = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            inputs.disko.nixosModules.disko
            inputs.impermanence.nixosModules.impermanence
            ./configuration.nix
            # ./impermanence.nix
            ./hardware-configuration.nix
            # ./disk.nix
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
