{config, ...}: let
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
  };

  home.persistence."/persist/${config.home.homeDirectory}".directories = [
    ".cache/spotify-player"
  ];
  xdg = {
    desktopEntries = {
      neomutt = {
        name = "Spotify Player";
        genericName = "Music Player";
        comment = "Play spotify from the commandline";
        exec = "spotify_player";
        icon = "spotify";
        terminal = true;
        categories = [
          "Music"
        ];
        type = "Application";
      };
    };
  };
}
