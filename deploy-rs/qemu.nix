{...}: {
  virtualisation.vmVariant = {
    # following configuration is added only when building VM with build-vm
    virtualisation = {
      memorySize = 2048; # Use 2048MiB memory.
      cores = 3;
      graphics = false;
    };
  };

  # user
  services.getty.autologinUser = "root";
  users.users.root.initialPassword = "root";
}
