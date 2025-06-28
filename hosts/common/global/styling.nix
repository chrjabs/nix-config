{
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];

  stylix = {
    enable = true;
    polarity = "dark";
    base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-hard.yaml";
    targets = {
      plymouth.enable = false;
      regreet.enable = false;
    };
    homeManagerIntegration.followSystem = false;
  };
}
