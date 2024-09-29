{pkgs, ...}: {
  imports = [
    ./global
    ./features/desktop/sway
    ./features/productivity
  ];

  home.sessionVariables.FLAKE = "/mnt/nix-config";

  monitors = [
    {
      name = "Virtual-1";
      width = 1920;
      height = 1080;
      primary = true;
    }
  ];
}
