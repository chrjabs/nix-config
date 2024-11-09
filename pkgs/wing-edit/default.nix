{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  alsa-lib,
  freetype,
  curl,
  libgcc,
}:
stdenv.mkDerivation rec {
  pname = "wing-edit";
  version = "3.1";

  src = fetchurl {
    url = "https://www.jabsserver.net/software/Wing-Edit_LINUX_${version}.tar.gz";
    hash = "sha256-3hHKv6KeinTsm5KGGIIuiGh8fH8+O/bkJqZIE+ap27c=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    alsa-lib
    freetype
    curl
    stdenv.cc.cc.lib
    libgcc
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    install -m755 -D WING-Edit $out/bin/wing-edit
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.behringer.com/wing/wing.html";
    description = "Editing software for Behring WING soundboard";
    platforms = platforms.linux;
  };
}
