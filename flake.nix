{
  description = "A tool for checking to see if directories have changed";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.03";

  outputs = { self, nixpkgs }: {
    overlay = self: super: {
      dirstamp = self.rustPlatform.buildRustPackage rec {
        pname = "dirstamp";
        version = "0.1.0";
        src = self;
        cargoSha256 = "14hq1kzdihwqg62wwky94qf570rifhyrrnf3av1076pf1ybqn5rq";
      };
    };
    defaultPackage.x86_64-linux = (import nixpkgs {
      system = "x86_64-linux";
      overlays = [ self.overlay ];
    }).dirstamp;
  };
}
