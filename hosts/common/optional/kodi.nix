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
    displayManager.lightdm.greeter.enable = false;
  };

  services.displayManager.autoLogin = {
    enable = true;
    user = "kodi";
  };

  users.extraUsers.kodi.isNormalUser = true;

  home-manager.users.kodi.home = {
    stateVersion = "24.11";
    file = {
      widevine-lib = {
        source = "${pkgs.widevine-cdm}/share/google/chrome/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so";
        target = ".kodi/cdm/libwidevinecdm.so";
      };
      widevine-manifest = {
        source = "${pkgs.widevine-cdm}/share/google/chrome/WidevineCdm/manifest.json";
        target = ".kodi/cdm/manifest.json";
      };
    };
  };
}
