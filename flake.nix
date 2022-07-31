{
  description = "A tool for checking to see if directories have changed";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        dirstamp = pkgs.rustPlatform.buildRustPackage rec {
          pname = "dirstamp";
          version = "0.1.0";
          src = self;
          cargoSha256 = "crJCTXFnlZ0LoKe0FrmDicKdiBGsPzt7NETdsfat0qo=";
        };
      in {
        devShell = pkgs.mkShell {
          buildInputs = [ pkgs.rustfmt pkgs.cargo ];
          shellHook = ''
            export RUST_BACKTRACE=full
          '';
        };
        defaultPackage = dirstamp;
      });
}
