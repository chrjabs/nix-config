{
  flake.nixosModules.systemdBoot = {
    boot = {
      loader = {
        systemd-boot = {
          enable = true;
          consoleMode = "max";
        };
        efi.canTouchEfiVariables = true;
      };
      initrd.systemd.enable = true;
    };
  };
}
