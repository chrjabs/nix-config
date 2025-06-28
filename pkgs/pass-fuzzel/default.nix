{
  lib,
  stdenv,
  makeWrapper,
  pass,
  jq,
  fuzzel,
  libnotify,
  wl-clipboard,
  wtype,
  findutils,
  gnused,
  coreutils,
}:
stdenv.mkDerivation {
  name = "pass-fuzzel";
  version = "1.0";
  src = ./pass-fuzzel.sh;

  nativeBuildInputs = [makeWrapper];

  dontUnpack = true;
  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    install -Dm 0755 $src $out/bin/pass-fuzzel
    wrapProgram $out/bin/pass-fuzzel --prefix PATH ':' \
      "${
      lib.makeBinPath [
        pass
        jq
        fuzzel
        libnotify
        wl-clipboard
        wtype
        findutils
        gnused
        coreutils
      ]
    }"
  '';

  meta = {
    description = "A fuzzel graphical menu for pass";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "pass-fuzzel";
  };
}
