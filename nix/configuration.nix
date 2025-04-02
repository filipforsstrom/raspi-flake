{pkgs, ...}: let
  # Define the gpio package once to avoid building it twice
  # gpioPackage = pkgs.callPackage ../src/gpio/nix/gpio.nix {};
in {
  imports = [];

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = {
      max-jobs = "auto";
      trusted-users = ["@wheel"];
    };
    gc = {
      automatic = true;
      randomizedDelaySec = "14m";
      options = "--delete-older-than 10d";
    };
  };
  documentation.nixos.enable = false;

  boot = {
    initrd.availableKernelModules = ["xhci_pci" "usbhid" "usb_storage"];

    loader = {
      grub.enable = false;
      # no need to set devices, disko will add all devices that have a EF02 partition to the list already
      # devices = [ ];
      grub.efiSupport = true;
      grub.efiInstallAsRemovable = true;
      generic-extlinux-compatible.enable = true;
      timeout = 2;
    };
  };

  # network
  networking.hostName = "raspi-nix";
  networking.firewall.allowedTCPPorts = [5000]; # Allow port for ASP.NET app

  # package
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    git
    gcc
    dotnetCorePackages.sdk_9_0
    # gpioPackage
  ];

  # environment.extraLibraryPaths = [
  #   "${gpioPackage}/lib"
  # ];

  # user
  users.users.ff = {
    isNormalUser = true;
    home = "/home/ff";
    description = "ff";
    extraGroups = ["wheel" "gpio"];
    openssh = {
      authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIl4TaNM1Y6/ibDsIKJHRxhLFXe8gUPCcektvx3gZ5Jw"
      ];
    };
  };

  security.sudo.wheelNeedsPassword = false;

  # service
  services.openssh.enable = true;
}
