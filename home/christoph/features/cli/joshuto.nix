{
  config,
  lib,
  ...
}: {
  programs.joshuto = {
    enable = true;

    settings = {
      xdg_open = true;
      xdg_open_fork = true;
      zoxide_update = true;
      cmd_aliases = {
        cd = "z";
        cdi = "zi";
      };
    };

    mimetype = {
      class = {
        audio_default = [
          {
            command = lib.getExe config.programs.mpv.package;
            args = ["--"];
          }
        ];
        image_default = [
          {
            command = lib.getExe config.programs.imv.package;
            args = ["--"];
          }
        ];
        video_default = [
          {
            command = lib.getExe config.programs.mpv.package;
            args = ["--"];
          }
        ];
        text_default = [
          {
            command = lib.getExe config.programs.nixvim.package;
          }
        ];
        reader_default = [
          {
            command = lib.getExe config.programs.zathura.package;
            fork = true;
            silent = true;
          }
        ];
      };

      mimetype = {
        application.subtype.octet-stream."inherit" = "video_default";
        text."inherit" = "text_default";
        video."inherit" = "text_default";
      };
    };
  };
}
