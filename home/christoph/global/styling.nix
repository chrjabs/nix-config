{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: {
  imports = [
    inputs.stylix.homeManagerModules.stylix
  ];

  recolor-wallpaper = {
    enable = true;
    theme = lib.mkDefault "gruvbox-material-dark-hard";
    wallpaper = lib.mkDefault "earth2";
  };

  specialisation.work.configuration.recolor-wallpaper = {
    theme = "catppuccin-frappe";
    wallpaper = "rocket";
  };

  stylix = {
    enable = true;
    fonts = {
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      monospace = {
        package = pkgs.fira-code-nerdfont;
        name = "Fira Code Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
}
