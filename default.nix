let
  pkgs = import (builtins.fetchTarball {
    name = "nixos-20.03-2020-07-28";
    url =
      "https://github.com/nixos/nixpkgs/archive/eeb91b03a5cef25c3931bdd4438f006a293adef9.tar.gz";
    sha256 = "00cqfmfry5rjhz4kyybr4jc4vzslkk3csy28w9k1qlyn8arpqv3s";
  }) { };
in { rustPlatform ? pkgs.rustPlatform, nix-gitignore ? pkgs.nix-gitignore }:
rustPlatform.buildRustPackage rec {
  pname = "dirstamp";
  version = "1.0.0";
  src = nix-gitignore.gitignoreSource [ ] ./.;
  cargoSha256 = "14hq1kzdihwqg62wwky94qf570rifhyrrnf3av1076pf1ybqn5rq";
}

