{
  lib,
  pkgs,
  config,
  bootstrap ? false,
  ...
}: {
  services.xserver = lib.mkIf (!bootstrap) {
    enable = true;
    desktopManager.kodi = {
      enable = true;
      package = pkgs.custom.kodi.withPackages (kodiPkgs:
        with kodiPkgs; [
          youtube
          netflix
          upnext
          mediacccde
          steam-controller
          mediathekview
          inputstream-adaptive
        ]);
    };
    displayManager.lightdm.greeter.enable = false;
  };

  services.displayManager.autoLogin = lib.mkIf (!bootstrap) {
    enable = true;
    user = config.users.extraUsers.kodi.name;
  };

  users.extraUsers.kodi.isNormalUser = lib.mkIf (!bootstrap) true;

  home-manager.users.kodi.home = lib.mkIf (!bootstrap) {
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

  sops.secrets.youtube-api = lib.mkIf (!bootstrap) {
    inherit (config.users.extraUsers.kodi) name group;
    sopsFile = ../../${config.networking.hostName}/kodi-secrets.yaml;
    path = "${config.users.extraUsers.kodi.home}/.kodi/userdata/addon_data/plugin.video.youtube/api_keys.json";
  };

  networking.firewall = lib.mkIf (!bootstrap) {
    allowedTCPPorts = [8080 9090];
    allowedUDPPorts = [8080 9090];
  };
}
