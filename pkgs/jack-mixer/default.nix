{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  cmake,
  glib,
  libjack2,
  python3,
  docutils,
  withGui ? false,
  withJackMidi ? true,
}:
assert lib.assertMsg (withGui || withJackMidi) "either GUI of JackMIDI needs to be enabled"; let
  pythonDeps = with python3.pkgs; [
    pygobject3
    pycairo
    platformdirs
    cython
  ];

  guiFlag =
    if withGui
    then "-Dgui=enabled"
    else "-Dgui=disabled";
  jackMidiFlag =
    if withJackMidi
    then "-Djack-midi=enabled"
    else "-Djack-midi=disabled";
in
  stdenv.mkDerivation
  rec {
    name = "jack-mixer";
    version = "19";

    src = fetchFromGitHub {
      owner = "jack-mixer";
      repo = "jack_mixer";
      rev = "release-${version}";
      hash = "sha256-ElpoDJ8DJI8bV3PEAPhtTxr2JgFcRBQIp1rxpVVSpqI=";
    };

    postPatch = ''
      # Fix installation path of xdg schemas.
      substituteInPlace meson.build --replace "'/'" "prefix"
    '';

    buildInputs = [
      glib
      libjack2
      python3
    ];

    propagatedBuildInputs = pythonDeps;

    nativeBuildInputs = [
      meson
      ninja
      pkg-config
      cmake
      docutils
    ];

    mesonFlags = [guiFlag jackMidiFlag];

    meta = {
      description = "A multi-channel audio mixer desktop application for the JACK Audio Connection Kit";
      homepage = "https://rdio.space/jackmixer/";
      changelog = "https://github.com/jack-mixer/jack_mixer/releases/tag/release-${version}";
      mainProgram = "jack_mixer";
      license = lib.licenses.gpl2Plus;
      maintainers = with lib.maintainers; [];
    };
  }
