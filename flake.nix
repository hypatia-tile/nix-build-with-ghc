{
  description = "Tiny project: build a Haskell program with GHC using Nix";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    supportedSystems = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    pkgsFor = system:
      import nixpkgs {
        inherit system;
      };
  in {
    packages = forAllSystems (system: let
      # pkgs = nixpkgs.legacyPackages.${system};
      pkgs = pkgsFor system;
    in {
      #   packages.${system}.default = pkgs.stdenv.mkDerivation {
      #     pname = "tiny-ghc-nix";
      #     version = "0.1.0";
      #     src = ./.;
      #
      #     nativeBuildInputs = [
      #       pkgs.ghc
      #     ];
      #
      #     buildPhase = ''
      #       mkdir -p build
      #       ghc -Wall -Werror app/Main.hs -o build/tiny-ghc-nix
      #     '';
      #
      #     installPhase = ''
      #       mkdir -p $out/bin
      #       cp build/tiny-ghc-nix $out/bin/tiny-ghc-nix
      #     '';
      #   };
      default = pkgs.stdenv.mkDerivation {
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
    });

    devShells = forAllSystems (system: let
      pkgs = pkgsFor system;
    in {
      #   devShells.${system}.default = pkgs.mkShell {
      #     packages = [
      #       pkgs.ghc
      #     ];
      #   };
      default = pkgs.mkShell {
        packages = [
          pkgs.ghc
        ];
      };
    });
  };
}
