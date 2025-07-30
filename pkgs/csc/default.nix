{
  lib,
  rustPlatform,
  fetchFromGitHub,
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

  cargoHash = "sha256-En+FI3yhkjOZ+6Y1m/a++jRP1mU3gyKLBVJ2TApA+Wg=";

  meta = {
    description = "Command Line Scientific Calculator. Free Forever. Made with ❤️ using 🦀 ";
    homepage = "https://github.com/zahash/csc";
    changelog = "https://github.com/zahash/csc/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chrjabs ];
    platforms = lib.platforms.all;
    mainProgram = "csc";
  };
}
