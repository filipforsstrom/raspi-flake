{
  description = "Base system for raspberry pi 4";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixos-generators,
    ...
  }: {
    nixosModules = {
      system = {
        system.stateVersion = "24.11";
      };
    };
    packages.x86_64-linux = {
      sdcard = nixos-generators.nixosGenerate {
        system = "aarch64-linux";
        format = "sd-aarch64";
        modules = [
          self.nixosModules.system
          ./hardware-configuration.nix # Generated by nixos-generate-config on a Raspberry Pi 4
          ./configuration.nix
          {
            sdImage.compressImage = false;
          }
        ];
      };
      vm = nixos-generators.nixosGenerate {
        system = "x86_64-linux";
        format = "vm-nogui";
        modules = [
          self.nixosModules.system
          ./configuration.nix
          ./qemu.nix
        ];
      };
    };
  };
}
