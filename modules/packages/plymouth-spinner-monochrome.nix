{
  perSystem =
    { pkgs, ... }:
    {
      packages.plymouth-spinner-monochrome = pkgs.callPackage (
        {
          stdenv,
          logo ? null,
          lib,
        }:
        stdenv.mkDerivation {
          pname = "plymouth-spinner-monochrome";
          version = "1.0";
          src = ./plymouth-spinner-monochrome-src;

          buildPhase = lib.optionalString (logo != null) ''
            ln -s ${logo} watermark.png
          '';
          installPhase = ''
            mkdir -p $out/share/plymouth/themes
            cp -rT . $out/share/plymouth/themes/spinner-monochrome
          '';

          meta = {
            platforms = lib.platforms.all;
          };
        }
      ) { };
    };
}
