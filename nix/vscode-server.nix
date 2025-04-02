{...}: {
  imports = [
    (builtins.fetchTarball {
      url = "https://github.com/nix-community/nixos-vscode-server/tarball/master";
      sha256 = "09j4kvsxw1d5dvnhbsgih0icbrxqv90nzf0b589rb5z6gnzwjnqf";
    })
  ];

  config = {
    services.vscode-server.enable = true;
  };
}
