{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.fuzzel = {
    enable = true;

    settings = {
      main = {
        width = 60;
        terminal = lib.getExe config.programs.kitty.package;
        layer = "overlay";
        line-height = 20;
      };
    };
  };

  home.packages = let
    inherit (config.programs.password-store) package enable;
  in
    lib.optional enable (pkgs.pass-fuzzel.override {pass = package;});
}
