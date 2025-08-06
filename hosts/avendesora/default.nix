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
    ../common/optional/home.nix
    ../common/optional/nginx.nix

    ./services

    (modulesPath + "/virtualisation/proxmox-image.nix")
  ];

  networking.hostName = lib.mkOverride 20 "avendesora";

  system.stateVersion = "25.11";

  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "i686-linux"
  ];

  # Proxmox VM options
  proxmox.qemuConf = {
    cores = 4;
    memory = 4096;
    bios = "ovmf";
    name = config.networking.hostName;
  };
  virtualisation.diskSize = 30720;
}
