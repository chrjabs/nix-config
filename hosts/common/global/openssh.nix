{
  outputs,
  lib,
  config,
  ...
}:
let
  hosts = lib.attrNames outputs.nixosConfigurations;

  # Sops needs acess to the keys before the persist dirs are mounted; so just persisting the keys won't work, we must point at /persist
  hasOptinPersistence =
    lib.hasAttr "persistence" config.environment
    && lib.hasAttr "/persist" config.environment.persistence
    && config.environment.persistence."/persist".enable;
in
{
  services.openssh = {
    enable = true;
    settings = {
      # Harden
      PasswordAuthentication = false;
      PermitRootLogin = "no";

      # Automatically remove stale sockets
      StreamLocalBindUnlink = "yes";
      # Allow forwarding ports to everywhere
      GatewayPorts = "clientspecified";
      # Let WAYLAND_DISPLAYbe forwarded
      AcceptEnv = "WAYLAND_DISPLAY";
      X11Forwarding = true;
    };
    hostKeys = [
      {
        path = "${lib.optionalString hasOptinPersistence "/persist"}/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  programs.ssh = {
    # Each hosts public key
    knownHosts = lib.genAttrs hosts (hostname: {
      publicKeyFile = ../../${hostname}/ssh_host_ed25519_key.pub;
      extraHostNames = lib.optional (hostname == config.networking.hostName) "localhost";
    });
  };

  # Passwordless sudo when SSH'ing with keys
  security.pam.sshAgentAuth = {
    enable = true;
    authorizedKeysFiles = [ "/etc/ssh/authorized_keys.d/%u" ];
  };
}
