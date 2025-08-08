{
  config,
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix

    ../common/global
    ../common/users/christoph

    ../common/optional/systemd-boot.nix
    ../common/optional/nginx.nix
  ];

  networking.hostName = "terangreal";

  system.stateVersion = "25.11";

  boot.binfmt.emulatedSystems = [
    "x86_64-linux"
    "i686-linux"
  ];
}
