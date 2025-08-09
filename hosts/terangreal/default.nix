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
    ../common/optional/optin-persistence.nix
  ];

  networking = {
    hostName = "terangreal";
    useDHCP = true;
    dhcpcd.IPv6rs = true;
    defaultGateway6 = {
      address = "fe80::1";
      interface = "enp1s0";
    };
    interfaces.enp1s0 = {
      useDHCP = true;
      wakeOnLan.enable = true;
      ipv4.addresses = [
        {
          address = "65.21.153.141";
          prefixLength = 32;
        }
      ];
      ipv6.addresses = [
        {
          address = "2a01:4f9:c012:eeb3::1";
          prefixLength = 64;
        }
      ];
    };
  };

  system.stateVersion = "25.11";

  boot.binfmt.emulatedSystems = [
    "x86_64-linux"
    "i686-linux"
  ];
}
