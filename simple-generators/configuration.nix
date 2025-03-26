{pkgs, ...}: {
  imports = [
    <nixos-hardware/raspberry-pi/4>
  ];

  boot.kernelParams = [
    "console=ttyS1,115200n8"
  ];

  hardware = {
    raspberry-pi."4".apply-overlays-dtmerge.enable = true;
    deviceTree = {
      enable = true;
      filter = "*rpi-4-*.dtb";
    };
  };
  console.enable = false;
  environment.systemPackages = with pkgs; [
    raspberrypi-eeprom
  ];
  networking.hostName = "nixpi";
  networking.firewall.enable = false;

  nixpkgs.config.allowUnfree = true;

  services.openssh.enable = true;
}
