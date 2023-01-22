{
  description = "A tool for checking to see if directories have changed";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    let
      withPkgs = pkgs: {
        devShells.default = pkgs.mkShell {
          buildInputs = [ pkgs.rustfmt pkgs.cargo ];
          shellHook = ''
            export RUST_BACKTRACE=full
          '';
        };
        packages.default = pkgs.rustPlatform.buildRustPackage rec {
          pname = "dirstamp";
          version = "0.1.0";
          src = self;
          cargoSha256 = "crJCTXFnlZ0LoKe0FrmDicKdiBGsPzt7NETdsfat0qo=";
        };
      };

    in (flake-utils.lib.eachDefaultSystem
      (system: withPkgs nixpkgs.legacyPackages.${system})) // {
        overlays.default = final: prev: {
          dirstamp = (withPkgs prev).packages.default;
        };
      };
}
