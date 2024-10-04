{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libarchive,
  cadical,
  python3,
}:
stdenv.mkDerivation rec {
  pname = "gbdc";
  version = "0.2.46";

  src = fetchFromGitHub {
    owner = "Udopia";
    repo = "gbdc";
    rev = "badb17af3dd63ff8c027fab053b53c110e9f2120";
    hash = "sha256-ZzVA5sODXwt5sgP9QL4ajv8yfa7JP4YCPmdtJDCfldQ=";
  };

  buildInputs = [
    libarchive
    cadical
  ];

  nativeBuildInputs = [
    cmake
    python3
  ];

  patches = [
    ./adjust-cmake-for-nix.patch
  ];

  meta = {
    description = "Instance Identification, Feature Extraction, and Problem Transformation";
    homepage = "https://github.com/Udopia/gbdc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [];
    mainProgram = "gbdc";
    platforms = lib.platforms.all;
  };
}
