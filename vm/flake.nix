{
  description = "VM";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (system: let
      testVm = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs.inputs = inputs;
        modules = [
          {
            virtualisation.vmVariant = {
              virtualisation = {
                memorySize = 2048;
                cores = 3;
                graphics = false;
              };
            };

            # user
            services.getty.autologinUser = "root";
            users.users.root.initialPassword = "root";
            system.stateVersion = "24.11";
          }
        ];
      };
    in {
      apps.default = {
        type = "app";
        program = "${testVm.config.system.build.vm}/bin/run-nixos-vm";
      };
    });
}
