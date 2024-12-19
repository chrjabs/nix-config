{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  stdenv,
  darwin,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "csc";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "zahash";
    repo = "csc";
    rev = "refs/tags/v${version}";
    hash = "sha256-EBMEoz2+5QxFAqT3zXa1OrcGJdChf8HrFk7BA4OUiiA=";
  };

  cargoHash = "sha256-N3cSvlHQBE2lxZc+UDz+eb1xhrbFJKFlpTDos5UbWxU=";

  # nativeBuildInputs = [ pkg-config ];

  meta = {
    description = "Command Line Scientific Calculator. Free Forever. Made with ❤️ using 🦀 ";
    homepage = "https://github.com/zahash/csc";
    changelog = "https://github.com/zahash/csc/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    platforms = lib.platforms.all;
    mainProgram = "csc";
  };
}
