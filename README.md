# raspi

## qemu

```shell
qemu-system-aarch64 \
  -M raspi4b \
  -m 2G \
  -kernel /home/ff/projects/raspi-flake/extracted-files/kernel.img \
  -dtb /home/ff/projects/raspi-flake/extracted-files/bcm2710-rpi-3-b-plus.dtb \
  -sd /home/ff/projects/raspi-flake/extracted-files/sd-image.img \
  -append "console=ttyAMA0,115200 root=/dev/mmcblk0p2 rootfstype=ext4 rw" \
  -serial stdio \
  -net nic \
  -net user,hostfwd=tcp::2222-:22
```

## raspberry-pi-nix

`nix build .#nixosConfigurations.rpi.config.system.build.sdImage`

## Cross compiling

### nixos-generator

[nixos-generator][nixos-generators-link]

[nixos-generators-example][nixos-generators-example-link]

`error: a 'aarch64-linux' with features {} is required to build '/nix/store/hkh7a28b8bbbsr8gm5qxfigdc0y7hb4k-config.txt.drv', but I am a 'x86_64-linux' with features {benchmark, big-parallel, kvm, nixos-test`

Solved by adding this to host:

`boot.binfmt.emulatedSystems = ["aarch64-linux"];`

## Links

[Using Nix as a Yocto Alternative][yocto-link]
[Cross Compile NixOS for Great Good][artemis-link]

[nixos-generators-link]: https://github.com/nix-community/nixos-generators
[yocto-link]: https://www.kdab.com/using-nix-as-a-yocto-alternative/
[artemis-link]: https://artemis.sh/2023/06/06/cross-compile-nixos-for-great-good.html
[nixos-generators-example-link]: https://github.com/jason-m/whydoesnothing.work/blob/main/episode-5/flake.nix
