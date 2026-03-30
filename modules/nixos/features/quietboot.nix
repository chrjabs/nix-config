{ self, ... }:
{
  flake.nixosModules.quietboot =
    { pkgs, config, ... }:
    {
      console = {
        useXkbConfig = true;
        earlySetup = false;
      };

      boot = {
        plymouth = {
          enable = true;
          theme = "spinner-monochrome";
          themePackages = [
            (self.outputs.packages.${pkgs.system}.plymouth-spinner-monochrome.override {
              inherit (config.boot.plymouth) logo;
            })
          ];
        };
        loader.timeout = 0;
        kernelParams = [
          "quiet"
          "loglevel=3"
          "systemd.show_status=auto"
          "udev.log_level=3"
          "rd.udev.log_level=3"
          "vt.global_cursor_default=0"
        ];
        consoleLogLevel = 0;
        initrd.verbose = 0;
      };
    };
}
