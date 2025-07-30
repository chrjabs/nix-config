{
  pkgs,
  config,
  lib,
  ...
}:
{
  options.recolor-wallpaper = with lib; {
    enable = mkEnableOption "recolor-wallpaper";

    theme = mkOption {
      type = types.str;
      description = "the base16 theme name to choose and set with stylix";
    };

    wallpaper = mkOption {
      type = types.str;
      description = "the name of the wallpaper to recolor and set";
    };
  };

  config = lib.mkIf config.recolor-wallpaper.enable {
    stylix =
      let
        themeName = config.recolor-wallpaper.theme;
        wallpaperName = config.recolor-wallpaper.wallpaper;
      in
      {
        enable = lib.mkDefault true;

        base16Scheme = "${pkgs.base16-schemes}/share/themes/${config.recolor-wallpaper.theme}.yaml";

        image =
          let
            magick = lib.getExe' pkgs.imagemagick "magick";
            theme = config.lib.stylix.colors.withHashtag;
            wallpaper = pkgs.wallpapers."${wallpaperName}".path;
            args = pkgs.wallpapers."${wallpaperName}".recolorArgs;
          in
          pkgs.runCommand "${wallpaperName}-${themeName}.png" { }
            # * bash
            ''
              # Create color palette image
              palette=$(mktemp XXXXXXXX.png)
              ${magick} -size 1x1 \
                xc:${theme.base00} \
                xc:${theme.base01} \
                xc:${theme.base02} \
                xc:${theme.base03} \
                xc:${theme.base04} \
                xc:${theme.base05} \
                xc:${theme.base06} \
                xc:${theme.base07} \
                xc:${theme.base08} \
                xc:${theme.base09} \
                xc:${theme.base0A} \
                xc:${theme.base0B} \
                xc:${theme.base0C} \
                xc:${theme.base0D} \
                xc:${theme.base0E} \
                xc:${theme.base0F} \
                -append $palette
              # Recolor wallpaper
              ${magick} ${wallpaper} ${args} -remap $palette $out
              rm $palette
            '';
      };
  };
}
