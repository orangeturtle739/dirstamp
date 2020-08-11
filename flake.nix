{
  description = "A tool for checking to see if directories have changed";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.03";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        dirstamp = pkgs.rustPlatform.buildRustPackage rec {
          pname = "dirstamp";
          version = "0.1.0";
          src = self;
          cargoSha256 = "14hq1kzdihwqg62wwky94qf570rifhyrrnf3av1076pf1ybqn5rq";
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
