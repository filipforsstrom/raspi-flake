{stdenv}:
stdenv.mkDerivation {
  pname = "gpio";
  version = "0.1.0";

  src = ../.;

  # Add an explicit buildPhase to build all targets
  buildPhase = ''
    # Create directories first
    mkdir -p ./bin ./lib

    # Build both the executable and the shared library
    make all
  '';

  # Define a custom installation phase
  installPhase = ''
    # Create the necessary directories in the Nix store output
    mkdir -p $out/bin $out/lib

    # Copy the compiled binaries and libraries to the Nix store
    cp ./bin/main $out/bin/
    cp ./lib/libgpio.so $out/lib/

    # Create symlink so it can be called as 'gpio'
    ln -s $out/bin/main $out/bin/gpio
  '';
}
