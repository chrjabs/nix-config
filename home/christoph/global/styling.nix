{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: {
  imports = [
    inputs.stylix.homeModules.stylix
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
    polarity = "dark";
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
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
    # cursor = {
    #   package = pkgs.vanilla-dmz;
    #   name = "Vanilla-DMZ";
    #   size = 24;
    # };
    cursor = {
      package = pkgs.vimix-cursors;
      name = "Vimix-cursors";
      size = 24;
    };
  };
}
