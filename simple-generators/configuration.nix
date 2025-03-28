{pkgs, ...}: {
  nix.settings.trusted-users = ["@wheel"];

  documentation.nixos.enable = false;

  console.enable = true;

  environment.systemPackages = with pkgs; [
    raspberrypi-eeprom
  ];

  nixpkgs.config.allowUnfree = true;

  services.openssh.enable = true;
  networking.firewall.allowedTCPPorts = [22];

  users.users.root.initialPassword = "root";
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIl4TaNM1Y6/ibDsIKJHRxhLFXe8gUPCcektvx3gZ5Jw"
  ];

  services.getty.autologinUser = "ff";

  users.users.ff = {
    isNormalUser = true;
    initialPassword = "nixos";
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIl4TaNM1Y6/ibDsIKJHRxhLFXe8gUPCcektvx3gZ5Jw"
    ];
  };

  security.sudo.wheelNeedsPassword = false;

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
    # useDHCP = true;
    # interfaces = {
    #   wlan0.useDHCP = false;
    #   eth0.useDHCP = true;
    # };
  };
}
