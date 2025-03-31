{...}: {
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
}
