{
  description = "Tiny project: build a Haskell program with GHC using Nix";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system}.default = pkgs.stdenv.mkDerivation {
      pname = "tiny-ghc-nix";
      version = "0.1.0";
      src = ./.;

      nativeBuildInputs = [
        pkgs.ghc
      ];

      buildPhase = ''
        mkdir -p build
        ghc -Wall -Werror app/Main.hs -o build/tiny-ghc-nix
      '';

      installPhase = ''
        mkdir -p $out/bin
        cp build/tiny-ghc-nix $out/bin/tiny-ghc-nix
      '';
    };
    devShells.${system}.default = pkgs.mkShell {
      packages = [
        pkgs.ghc
      ];
    };
  };
}
