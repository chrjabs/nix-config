{pkgs, ...}: {
  imports = [
    ./global
    ./features/desktop/sway
    ./features/productivity
    ./features/rust
  ];
}
