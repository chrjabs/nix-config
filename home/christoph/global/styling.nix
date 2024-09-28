{
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.stylix.homeManagerModules.stylix
  ];

  recolor-wallpaper = {
    enable = true;
    theme = "catppuccin-macchiato";
    wallpaper = "earth2";
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
