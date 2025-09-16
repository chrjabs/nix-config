{
  lib,
  config,
  bootstrap,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix

    ../common/global
    ../common/users/christoph

    ../common/optional/home.nix

    ../common/optional/systemd-boot.nix
    ../common/optional/optin-persistence.nix
    ../common/optional/greetd.nix
  ]
  ++ lib.optionals (!bootstrap) [
    ../common/optional/quietboot.nix
    ../common/optional/pipewire.nix
    ../common/optional/peripherals/ibus.nix
    ../common/optional/uh-vpn.nix
    ../common/optional/niri.nix
    ../common/optional/virtualization.nix
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
}
