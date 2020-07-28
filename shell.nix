with import <nixpkgs> { };

stdenv.mkDerivation {
  name = "rust-env";
  nativeBuildInputs = [ rustc cargo rustfmt ];

  # Set Environment Variables
  RUST_BACKTRACE = 1;
}
