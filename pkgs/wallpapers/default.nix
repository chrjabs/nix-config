{pkgs}:
pkgs.lib.listToAttrs (
  map (wallpaper: {
    inherit (wallpaper) name;
    value = {path = pkgs.fetchurl {
      inherit (wallpaper) sha256;
      name = "${wallpaper.name}.png";
      url = "https://www.jabsserver.net/wallpapers/${wallpaper.name}.png";
    }; inherit (wallpaper) recolorArgs; };
  })
  [
    {
      name = "rocket";
      sha256 = "cfbcbc05c8169282f805c907120c068586c0ce07b2a14822d7e9e420961f0212";
      recolorArgs = "-colors 16 +dither";
    }
    {
      name = "earth";
      sha256 = "396ccb8da855e4dad8d613f48cc034874f785e0bb0a50e193744b88bcfb764d4";
      recolorArgs = "-colors 16 +dither";
    }
    {
      name = "droids";
      sha256 = "b2eb30ac376deb8e4c996878939b71d615337687666802fdf62a9521be8a6a09";
      recolorArgs = "-colors 16";
    }
    {
      name = "solar-system";
      sha256 = "45e7f2dd8807a855cc2727708625c9cc6245986bcd8e692d1d09b554374a1d7d";
      recolorArgs = "";
    }
    {
      name = "mirage";
      sha256 = "3f7a6b1af30d2c787b56af842e1e0da6cfd77103e8241aa53ba0231da7b223f2";
      recolorArgs = "-colors 16 +dither";
    }
    {
      name = "northern-lights";
      sha256 = "6d255fb21bde5176fd9a7a62342a5ebde80d216f2dc94351df468fcb9253f049";
      recolorArgs = "-colors 16 +dither";
    }
    {
      name = "eclipse";
      sha256 = "a131a794125b8b4293f27431e5b351387989fa668077c2e651917c4bb691a160";
      recolorArgs = "-colors 16 +dither";
    }
    {
      name = "paint-brush";
      sha256 = "c73eff46de1a44f706b431f651e65c3e8ffc8cae5c0933545c5585d99ec565ad";
      recolorArgs = "-colors 16 +dither";
    }
    {
      name = "earth2";
      sha256 = "d7a381768a5fb0b6861abe09c6d992496853f9850c7649837f0473c44f615048";
      recolorArgs = "-colors 16 +dither";
    }
  ]
)
