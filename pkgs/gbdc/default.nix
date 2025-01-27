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
  version = "0.2.47";

  src = fetchFromGitHub {
    owner = "Udopia";
    repo = "gbdc";
    rev = "129aa99304cc64a9a2137b784c72967f845ae40e";
    hash = "sha256-fsqnCMUX9gMpeal39eLQj6U+4ulLlcuMbTg3hruL7R0=";
  };

  buildInputs = [
    libarchive
    cadical
  ];

  nativeBuildInputs = [
    cmake
    (python3.withPackages (python-pkgs:
      with python-pkgs; [
        pybind11
      ]))
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
