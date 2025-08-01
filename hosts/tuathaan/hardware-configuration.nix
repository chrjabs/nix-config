# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../common/optional/systemd-initrd.nix
    ../common/optional/single-disk-encrypted.nix
    ../common/optional/ephemeral-btrfs.nix
  ];

  boot = {
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "usb_storage"
        "sd_mod"
        "cryptd"
        "aes"
      ];
      kernelModules = [ ];
      luks = {
        fido2Support = false;
        # Luks with yubikey in systemd-cryptenroll
        # https://discourse.nixos.org/t/fde-using-systemd-cryptenroll-with-fido2-key/47762
        devices.${config.networking.hostName}.crypttabExtraOpts = [ "fido2-device=auto" ];
      };
    };
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
  };

  hardware.cpu.amd.updateMicrocode = true;

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp5s0.useDHCP = lib.mkDefault true;

  disko.devices.disk.${config.networking.hostName}.device = lib.mkForce "/dev/nvme0n1";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
