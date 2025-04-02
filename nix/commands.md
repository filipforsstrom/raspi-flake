nix run nixpkgs#nixos-anywhere -- --flake .#dev --generate-hardware-config nixos-generate-config ./hardware-configuration.nix <hostname>

nix run github:serokell/deploy-rs -- .#raspi-nix --hostname 192.168.1.238 --ssh-user ff