{ inputs, ... }:
{
  flake.nixosModules.base =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
      imports = [
        inputs.stylix.nixosModules.stylix
      ];

      options.styling = {
        enable = lib.mkEnableOption "enable global styling";

        polarity = lib.mkOption {
          type = lib.types.str;
          default = "dark";
          description = "the theme polarity, either dark or light";
        };

        theme = lib.mkOption {
          type = lib.types.str;
          default = "gruvbox-material-dark-hard";
          description = "the base16 theme name to choose and set with stylix";
        };

        wallpaperName = lib.mkOption {
          type = lib.types.str;
          default = "earth2";
          description = "the name of the wallpaper to set";
        };

        wallpaper = lib.mkOption {
          readOnly = true;
          description = "the path to the styled wallpaper to be used in other places";
        };

        recolorWallpaper = lib.mkEnableOption "enable wallpaper recoloring";

        fonts = {
          serif = lib.mkOption {
            default = {
              package = pkgs.dejavu_fonts;
              name = "DejaVu Serif";
            };
          };
          sansSerif = lib.mkOption {
            default = {
              package = pkgs.dejavu_fonts;
              name = "DejaVu Sans";
            };
          };
          monospace = lib.mkOption {
            default = {
              package = pkgs.nerd-fonts.fira-code;
              name = "FiraCode Nerd Font";
            };
          };
          emoji = lib.mkOption {
            default = {
              package = pkgs.noto-fonts-color-emoji;
              name = "Noto Color Emoji";
            };
          };
        };

        cursor = lib.mkOption {
          default = {
            package = pkgs.vimix-cursors;
            name = "Vimix-cursors";
            size = 24;
          };
        };

      };

      config =
        let
          cfg = config.styling;
        in
        lib.mkIf cfg.enable {
          styling.wallpaper =
            let
              wallpapers =
                lib.attrsets.mapAttrs
                  (name: data: {
                    path = pkgs.fetchurl {
                      name = "${name}.png";
                      inherit (data) sha256;
                      url = "https://www.jabsserver.net/wallpapers/${name}.png";
                    };
                    inherit (data) recolorArgs;
                  })
                  {
                    rocket = {
                      sha256 = "cfbcbc05c8169282f805c907120c068586c0ce07b2a14822d7e9e420961f0212";
                      recolorArgs = "-colors 16 +dither";
                    };
                    earth = {
                      sha256 = "396ccb8da855e4dad8d613f48cc034874f785e0bb0a50e193744b88bcfb764d4";
                      recolorArgs = "-colors 16 +dither";
                    };
                    droids = {
                      sha256 = "b2eb30ac376deb8e4c996878939b71d615337687666802fdf62a9521be8a6a09";
                      recolorArgs = "-colors 16";
                    };
                    solar-system = {
                      sha256 = "45e7f2dd8807a855cc2727708625c9cc6245986bcd8e692d1d09b554374a1d7d";
                      recolorArgs = "";
                    };
                    mirage = {
                      sha256 = "3f7a6b1af30d2c787b56af842e1e0da6cfd77103e8241aa53ba0231da7b223f2";
                      recolorArgs = "-colors 16 +dither";
                    };
                    northern-lights = {
                      sha256 = "6d255fb21bde5176fd9a7a62342a5ebde80d216f2dc94351df468fcb9253f049";
                      recolorArgs = "-colors 16 +dither";
                    };
                    eclipse = {
                      sha256 = "a131a794125b8b4293f27431e5b351387989fa668077c2e651917c4bb691a160";
                      recolorArgs = "-colors 16 +dither";
                    };
                    paint-brush = {
                      sha256 = "c73eff46de1a44f706b431f651e65c3e8ffc8cae5c0933545c5585d99ec565ad";
                      recolorArgs = "-colors 16 +dither";
                    };
                    earth2 = {
                      sha256 = "d7a381768a5fb0b6861abe09c6d992496853f9850c7649837f0473c44f615048";
                      recolorArgs = "-colors 16 +dither";
                    };
                  };
            in
            if cfg.recolorWallpaper then
              (
                let
                  magick = lib.getExe' pkgs.imagemagick "magick";
                  theme = config.lib.stylix.colors.withHashtag;
                  wallpaper = wallpapers.${cfg.wallpaperName}.path;
                  args = wallpapers.${cfg.wallpaperName}.recolorArgs;
                in
                pkgs.runCommand "${cfg.wallpaperName}-${cfg.theme}.png" { }
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
                  ''
              )
            else
              (wallpapers.${cfg.wallpaperName}.path);

          stylix = {
            enable = true;

            polarity = cfg.polarity;

            base16Scheme = "${pkgs.base16-schemes}/share/themes/${cfg.theme}.yaml";

            image = cfg.wallpaper;

            targets = {
              plymouth.enable = false;
              regreet.enable = false;
            };
          };
        };
    };
}
