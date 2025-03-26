# {
#   description = "Base system for raspberry pi 4";
#   inputs = {
#     nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
#     nixos-generators = {
#       url = "github:nix-community/nixos-generators";
#       inputs.nixpkgs.follows = "nixpkgs";
#     };
#   };
#   outputs = {
#     self,
#     nixpkgs,
#     nixos-generators,
#     ...
#   }: {
#     nixosModules = {
#       system = {
#         system.stateVersion = "24.11";
#       };
#       users = {
#         users.users = {
#           admin = {
#             password = "admin123";
#             isNormalUser = true;
#             extraGroups = ["wheel"];
#           };
#         };
#       };
#     };
#     packages.aarch64-linux = {
#       sdcard = nixos-generators.nixosGenerate {
#         system = "aarch64-linux";
#         format = "sd-aarch64";
#         modules = [
#           ./configuration.nix
#           self.nixosModules.system
#           self.nixosModules.users
#         ];
#       };
#     };
#   };
# }
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
    packages.x86_64-linux = {
      sdcard = nixos-generators.nixosGenerate {
        system = "aarch64-linux";
        format = "sd-aarch64";
        modules = [
          {
            boot.kernelParams = [
              "console=ttyS1,115200n8"
            ];

            nix.settings.trusted-users = ["@wheel"];

            documentation.nixos.enable = false;

            # hardware = {
            #   raspberry-pi."4".apply-overlays-dtmerge.enable = true;
            #   deviceTree = {
            #     enable = true;
            #     filter = "*rpi-4-*.dtb";
            #   };
            # };
            console.enable = true;
            environment.systemPackages = with nixpkgs; [
              # raspberrypi-eeprom
            ];
            networking.firewall.enable = false;

            nixpkgs.config.allowUnfree = true;

            services.openssh.enable = true;

            users.users.nixos = {
              isNormalUser = true;
              initialPassword = "123";
              description = "ff";
              extraGroups = [
                "wheel"
              ];
            };

            # Set your time zone.
            time.timeZone = "Europe/Stockholm";

            # Select internationalisation properties.
            i18n.defaultLocale = "en_US.UTF-8";

            i18n.extraLocaleSettings = {
              LC_ADDRESS = "sv_SE.UTF-8";
              LC_IDENTIFICATION = "sv_SE.UTF-8";
              LC_MEASUREMENT = "sv_SE.UTF-8";
              LC_MONETARY = "sv_SE.UTF-8";
              LC_NAME = "sv_SE.UTF-8";
              LC_NUMERIC = "sv_SE.UTF-8";
              LC_PAPER = "sv_SE.UTF-8";
              LC_TELEPHONE = "sv_SE.UTF-8";
              LC_TIME = "sv_SE.UTF-8";
            };

            # Configure console keymap
            console.keyMap = "sv-latin1";

            networking = {
              hostName = "raspi-nix";
              useDHCP = true;
              interfaces = {
                wlan0.useDHCP = false;
                eth0.useDHCP = true;
              };
            };

            system.stateVersion = "24.11";

            sdImage.compressImage = false;
          }
        ];
      };
    };
  };
}
