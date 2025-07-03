{
  pkgs,
  config,
  lib,
  ...
}: {
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "Christoph Jabs";
        email = lib.mkDefault "contact@christophjabs.info";
      };
      ui.default-command = "log";
      signing = {
        behaviour = "drop";
        backend = "gpg";
        key = "217C6A439646D51E";
        backends.gpg.program = lib.getExe config.programs.gpg.package;
      };
      git = {
        executable-path = lib.getExe config.programs.git.package;
        sign-on-push = lib.mkDefault true;
      };
      "--scope" = [
        {
          "--when".commands = ["diff" "show"];
          ui = {
            pager = lib.getExe pkgs.delta;
            diff-formatter = ":git";
          };
        }
      ];
    };
  };

  specialisation.work.configuration.programs.jujutsu.settings.user.email = "christoph.jabs@helsinki.fi";
}
