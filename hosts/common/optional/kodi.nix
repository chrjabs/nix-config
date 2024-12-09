{pkgs, ...}: {
  services.xserver = {
    enable = true;
    desktopManager.kodi = {
      enable = true;
      package = pkgs.kodi.withPackages (kodiPkgs:
        with kodiPkgs; [
          youtube
          netflix
          upnext
        ]);
    };
    displayManager.lightdm.greeter.enable = false;
  };

  services.displayManager.autoLogin = {
    enable = true;
    user = config.users.extraUsers.kodi.name;
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

  sops.secrets.youtube-api = {
    sopsFile = ../../${config.networking.hostName}/kodi-secrets.yaml;
    owner = config.users.extraUsers.kodi.name;
    group = config.users.extraUsers.kodi.group;
    path = "${config.users.extraUsers.kodi.home}/.kodi/userdata/addon_data/plugin.video.youtube/api_keys.json";
  };

  networking.firewall = {
    allowedTCPPorts = [8080];
    allowedUDPPorts = [8080];
  };
}
