{ config, ... }:
{
  hardware.bluetooth.enable = true;

  # Wireless secrets stored through sops
  sops.secrets.wireless = {
    sopsFile = ../secrets.yaml;
    owner = config.systemd.services.wpa_supplicant.serviceConfig.User;
  };

  networking.wireless = {
    enable = true;
    fallbackToWPA2 = false;
    secretsFile = config.sops.secrets.wireless.path;

    # Declarative
    networks = {
      "Spectrum" = {
        pskRaw = "ext:Spectrum";
      };
      "Spectrum-portable" = {
        pskRaw = "ext:Portable";
      };
      "JABSUNIFI" = {
        pskRaw = "ext:Jabsunifi";
      };
      "eduroam" = {
        authProtocols = [ "WPA-EAP" ];
        auth = ''
          pairwise=CCMP
          group=CCMP TKIP
          eap=PEAP
          ca_cert="${./eduroam-cert.pem}"
          identity="chrisjab@helsinki.fi"
          password=ext:eduroam
          phase2="auth=MSCHAPV2"
          anonymous_identity="anonymous@helsinki.fi"
          altsubject_match="DNS:rad-proxy.fe.helsinki.fi"
        '';
      };
    };

    # Imperative
    allowAuxiliaryImperativeNetworks = true;
  };

  # Ensure group exists
  users.groups.network = { };
}
