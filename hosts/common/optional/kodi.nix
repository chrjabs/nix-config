{pkgs, ...}: {
  services.xserver = {
    enable = true;
    desktopManager.kodi = {
      enable = true;
      package = pkgs.kodi.withPackages (kodiPkgs:
        with kodiPkgs; [
          jellyfin
          youtube
          netflix
        ]);
    };
    displayManager = {
      autoLogin.enable = true;
      autoLogin.user = "kodi";
      lightdm.greeter.enable = false;
    };
  };

  users.extraUsers.kodi.isNormalUser = true;

  home-manager.users.kodi = import ../../../../home/christoph/${config.networking.hostName}.nix;
}
