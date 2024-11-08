{
  config,
  pkgs,
  lib,
  ...
}: let
  pass = "${config.programs.password-store.package}/bin/pass";
in {
  programs.spotify-player = {
    enable = true;
    settings = {
      client_id_command = "${pass} spotify-client-id";
      notify_format = {
        summary = "{track}";
        body = "{artists} • {album}";
      };
      device = {
        volume = 100;
        audio_cache = true;
      };
    };
    package = pkgs.spotify-player.overrideAttrs (oldAttrs: rec {
      version = "0.20.1";
      src = pkgs.fetchFromGitHub {
        owner = "aome510";
        repo = oldAttrs.pname;
        rev = "refs/tags/v${version}";
        hash = "sha256-heycCm2Nwyo+DegMKeXZ+dF+ZqiFT/6P08/28buJc6I=";
      };
      cargoDeps = oldAttrs.cargoDeps.overrideAttrs (lib.const {
        name = "${oldAttrs.pname}-${version}-vendor.tar.gz";
        inherit src;
        outputHash = "sha256-G0h9/+U8xOF5iVTD5G9ftPU/odfwx/yWI4COmsaXEcs=";
      });
    });
  };

  home.persistence."/persist/${config.home.homeDirectory}".directories = [
    ".cache/spotify-player"
  ];
}
