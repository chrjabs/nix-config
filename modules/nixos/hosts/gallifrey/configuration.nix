{ self, inputs, ... }:
{
  flake.nixosConfigurations.gallifrey = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      bootstrap = false;
    };
    modules = [
      self.nixosModules.hostGallifrey
    ];
  };

  flake.nixosModules.hostGallifrey =
    {
      lib,
      config,
      bootstrap,
      ...
    }:
    {
      imports = [
        self.nixosModules.systemdBoot
        self.nixosModules.singleDiskEncrypted

        self.nixosModules.base
        self.nixosModules.impermanence

        self.nixosModules.userChristoph

        self.nixosModules.homeDns

        self.nixosModules.greetd
      ]
      ++ lib.optionals (!bootstrap) [
        self.nixosModules.quietboot
        self.nixosModules.pipewire
        self.nixosModules.ibus
        self.nixosModules.niri
        self.nixosModules.virtualisation
        self.nixosModules.workMode
      ];

      networking.hostName = "gallifrey";

      system.stateVersion = "25.05";

      boot.binfmt.emulatedSystems = [
        "aarch64-linux"
        "i686-linux"
      ];

      greetd.custom = {
        autoLogin = {
          enable = true;
          user = "christoph";
          command = "${lib.getExe' config.programs.niri.package "niri-session"} -l";
        };
        # Greetd output config
        outputConfig = lib.concatStringsSep "\n" [
          "output HDMI-A-1 disable"
          "output DP-1 enable"
        ];
      };

      # Needed for GTK
      programs.dconf.enable = true;

      # Nvidia GPU
      nixpkgs.config.allowUnfree = true;
      hardware = {
        graphics.enable = true;
        nvidia = {
          modesetting.enable = true;
          powerManagement.enable = false;
          powerManagement.finegrained = false;
          open = false;
          nvidiaSettings = true;
          package = config.boot.kernelPackages.nvidiaPackages.stable;
        };
      };
      services.xserver.videoDrivers = [ "nvidia" ];

      # Home assistant API token secret
      sops.secrets.ha-api-token = {
        inherit (config.users.users.nobody) name group;
        sopsFile = ./secrets.yaml;
        mode = "0444";
      };
      home-manager.extraSpecialArgs.haApiToken = config.sops.secrets.ha-api-token.path;

      workMode.enable = true;
    };
}
