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
      pkgs = pkgsFor system;
    in {
      default = let
        ghcWithDeps = pkgs.haskellPackages.ghcWithPackages (hpkgs: [
          hpkgs.ansi-terminal
        ]);
      in
        pkgs.stdenv.mkDerivation {
          pname = "tiny-ghc-nix";
          version = "0.1.0";
          src = ./.;

          nativeBuildInputs = [
            ghcWithDeps
          ];

          buildPhase = ''
            mkdir -p build/objects build/interfaces
            ghc \
              -Wall \
              -Werror \
              -isrc \
              src/Main.hs \
              -outputdir build/objects \
              -odir build/objects \
              -hidir build/interfaces \
              -o build/tiny-ghc-nix
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
      default = pkgs.mkShell {
        packages = [
          pkgs.ghc
        ];
      };
    });
  };
}
