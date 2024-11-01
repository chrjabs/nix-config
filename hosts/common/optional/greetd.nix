{
  pkgs,
  lib,
  config,
  ...
}: let
  homeCfgs = config.home-manager.users;
  homeSharePaths = lib.mapAttrsToList (_: v: "${v.home.path}/share") homeCfgs;
  vars = ''XDG_DATA_DIRS="$XDG_DATA_DIRS:${lib.concatStringsSep ":" homeSharePaths}" GTK_USE_PORTAL=0'';

  christophCfg = homeCfgs.christoph;

  sway-kiosk = command: "${lib.getExe pkgs.sway} --unsupported-gpu --config ${pkgs.writeText "kiosk.config" ''
    ${config.greetd.custom.outputConfig}
    xwayland disable
    input "type:touchpad" {
      tap enabled
    }
    exec '${vars} ${command}; ${pkgs.sway}/bin/swaymsg exit'
  ''}";
in {
  options.greetd.custom = with lib; {
    outputConfig = mkOption {
      type = types.str;
      default = "output * bg #000000 solid_color";
      description = "the sway output configuration for the greeter";
    };
  };

  config = {
    users.extraUsers.greeter = {
      # For caching and such
      home = "/tmp/greeter-home";
      createHome = true;
    };

    programs.regreet = {
      enable = true;
      settings.background = {
        path = pkgs.wallpapers."${christophCfg.recolor-wallpaper.wallpaper}".path;
        fit = "Cover";
      };
    };
    services.greetd = {
      enable = true;
      settings.default_session.command = sway-kiosk (lib.getExe config.programs.regreet.package);
    };
  };
}
