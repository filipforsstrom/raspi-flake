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
              wlan0.useDHCP = false;
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

    packages = {
      aarch64-linux = {
        default = self.nixosConfigurations.rpi.config.system.build.sdImage;
      };
    };

    image = self.nixosConfigurations.rpi.config.system.build.sdImage;

    vm = pkgs.writeScript "run-nixos-vm" ''
      #!${pkgs.runtimeShell}

      img=aarch64-qemu.img
      cp ${self.outputs.packages.${system}.default}/sd-image/*.img "$img"
      chmod 0640 "$img"

      mount_dir=$(mktemp -d)
      sudo mount -o loop,offset=$((512*16384)) -t vfat "$img" "$mount_dir"
      cp "$mount_dir/kernel.img" .
      sudo umount "$mount_dir"
      rmdir "$mount_dir"

      qemu-img resize -f raw "$img" 4G

      qemu-system-aarch64 \
      -machine raspi4b \
      -cpu max \
      -m 2G \
      -smp 4 \
      -kernel kernel.img \
      -dtb "${pkgs.device-tree_rpi}/broadcom/bcm2838-rpi-4-b.dtb" \
      -drive file="$img",format=raw,index=0,media=disk \
      -device usb-kbd \
      -device usb-mouse \
      -device usb-net,netdev=net0 \
      -netdev user,id=net0,hostfwd=tcp::2222-:22 \
      -append "rw earlyprintk loglevel=8 console=ttyAMA1,115200 dwc_otg.lpm_enable=0 root=/dev/mmcblk1p2 rootdelay=1" \
      -serial stdio \
      -no-reboot
    '';
  };
}
