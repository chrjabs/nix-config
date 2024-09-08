{pkgs, ...}: {
  imports = [
    ./global
    ./features/desktop/sway
  ];
}
