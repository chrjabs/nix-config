{
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")

    ../common/optional/systemd-initrd.nix
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "ata_piix"
        "uhci_hcd"
        "virtio_pci"
        "sr_mod"
        "virtio_blk"
      ];
      kernelModules = [ ];
    };
    kernelModules = [ ];
    extraModulePackages = [ ];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
