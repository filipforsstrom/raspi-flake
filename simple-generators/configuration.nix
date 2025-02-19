{
  config,
  lib,
  pkgs,
  ...
}: {
  # boot = {
  #   kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_rpi4;
  #   kernelParams = ["earlyprintk" "loglevel=8" "console=ttyAMA0,115200" "cma=256M"];
  # };
  networking.hostName = "nixpi";
  networking.firewall.enable = false;

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    openssh
  ];

  services.openssh.enable = true;
}
