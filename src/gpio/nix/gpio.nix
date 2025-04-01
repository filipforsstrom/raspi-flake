{stdenv}:
stdenv.mkDerivation {
  pname = "gpio";
  version = "0.1.0";

  src = ../.;

  # Skip the standard make install process
  dontInstall = false;

  # Define a custom installation phase
  installPhase = ''
    # Create the necessary directories in the Nix store output
    mkdir -p $out/bin $out/lib

    # Copy the compiled binaries and libraries to the Nix store
    cp ./bin/main $out/bin/
    cp ./lib/libgpio.so $out/lib/
  '';
}
