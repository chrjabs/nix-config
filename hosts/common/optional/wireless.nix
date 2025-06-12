{config, ...}: {
  hardware.bluetooth.enable = true;

  # Wireless secrets stored through sops
  sops.secrets.wireless = {
    sopsFile = ../secrets.yaml;
    neededForUsers = true;
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
      "eduroam" = {
        authProtocols = ["WPA-EAP"];
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
    # https://discourse.nixos.org/t/is-networking-usercontrolled-working-with-wpa-gui-for-anyone/29659
    extraConfig = ''
      ctrl_interface=DIR=/run/wpa_supplicant GROUP=${config.users.groups.network.name}
      update_config=1
    '';
  };

  # Ensure group exists
  users.groups.network = {};

  systemd.services.wpa_supplicant.preStart = "touch /etc/wpa_supplicant.conf";
}
