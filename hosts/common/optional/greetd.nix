{
  pkgs,
  lib,
  config,
  bootstrap ? false,
  ...
}:
let
  homeCfgs = config.home-manager.users;
  homeSharePaths = lib.mapAttrsToList (_: v: "${v.home.path}/share") homeCfgs;
  vars = ''XDG_DATA_DIRS="$XDG_DATA_DIRS:${lib.concatStringsSep ":" homeSharePaths}" GTK_USE_PORTAL=0'';

  christophCfg = homeCfgs.christoph;

  sway-kiosk =
    command:
    "${lib.getExe pkgs.sway} --unsupported-gpu --config ${pkgs.writeText "kiosk.config" ''
      ${config.greetd.custom.outputConfig}
      xwayland disable
      input "type:touchpad" {
        tap enabled
      }
      exec '${vars} ${command}; ${lib.getExe' pkgs.sway "swaymsg"} exit'
    ''}";
in
{
  options.greetd.custom = with lib; {
    outputConfig = mkOption {
      type = types.str;
      default = "output * bg #000000 solid_color";
      description = "the sway output configuration for the greeter";
    };
    autoLogin = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "enable auto login";
      };
      user = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "the user to auto login";
      };
      command = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "the command of the auto login session";
      };
    };
  };

  config = {
    users.extraUsers.greeter = {
      # For caching and such
      home = "/tmp/greeter-home";
      createHome = true;
      isSystemUser = true;
      group = "greeter";
    };
    users.groups.greeter = { };

    programs.regreet = {
      enable = lib.mkDefault true;
      settings.background = lib.mkIf (!bootstrap) {
        inherit (pkgs.wallpapers."${christophCfg.recolor-wallpaper.wallpaper}") path;
        fit = "Cover";
      };
    };
    services.greetd = {
      enable = lib.mkDefault true;
      settings = {
        default_session.command = sway-kiosk (lib.getExe config.programs.regreet.package);
        initial_session = lib.mkIf config.greetd.custom.autoLogin.enable {
          inherit (config.greetd.custom.autoLogin) command user;
        };
      };
    };
  };
}
