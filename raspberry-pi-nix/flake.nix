{
  description = "Minimal flake for building an RPi SD image";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    raspberry-pi-nix.url = "github:nix-community/raspberry-pi-nix";
  };

  outputs = {
    self,
    nixpkgs,
    raspberry-pi-nix,
    ...
  }: let
    system = "aarch64-linux";
    pkgs = import nixpkgs {inherit system;};
  in {
    nixosConfigurations.rpi = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        raspberry-pi-nix.nixosModules.raspberry-pi
        raspberry-pi-nix.nixosModules.sd-image
        {
          raspberry-pi-nix.board = "bcm2711";

          users.users.root.initialPassword = "root";

          time.timeZone = "Europe/Stockholm";
          networking = {
            hostName = "raspi-nix";
            useDHCP = false;
            interfaces = {
              wlan0.useDHCP = true;
              eth0.useDHCP = true;
            };
          };
          networking.firewall.enable = false;

          environment.systemPackages = with pkgs; [
            openssh
          ];

          services.openssh.enable = true;

          system.stateVersion = "24.11";

          sdImage.compressImage = false;
        }
      ];
    };
  };
}
