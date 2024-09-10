{pkgs, ...}: {
  imports = [
    ./global
    ./features/desktop/sway
  ];

  monitors = [
    {
      name = "Virtual-1";
      width = 1920;
      height = 1080;
      primary = true;
    }
  ];
}
