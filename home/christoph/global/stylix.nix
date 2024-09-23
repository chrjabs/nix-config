{
  pkgs,
  inputs,
  config,
  ...
}: let
  baseColorScheme = config.lib.base16.mkSchemeAttrs "${pkgs.base16-schemes}/share/themes/onedark.yaml";
in {
  imports = [
    inputs.base16.homeManagerModule
    inputs.stylix.homeManagerModules.stylix
  ];

  stylix = {
    enable = true;
    image = pkgs.wallpapers.deer;
    # override = {
    #   base08 = baseColorScheme.base08;
    #   base0B = baseColorScheme.base0B;
    # };
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
