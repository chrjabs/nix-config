{ self, ... }:
{
  flake.nixosModules.base =
    {
      lib,
      config,
      ...
    }:
    let
      hosts = lib.attrNames self.outputs.nixosConfigurations;
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
          # Let WAYLAND_DISPLAY be forwarded
          AcceptEnv = [ "WAYLAND_DISPLAY" ];
          X11Forwarding = true;
        };
        hostKeys = [
          {
            path = "${lib.optionalString config.persistence.enable "/persist"}/etc/ssh/ssh_host_ed25519_key";
            type = "ed25519";
          }
        ];
      };

      programs.ssh = {
        # Each hosts public key
        knownHosts = lib.genAttrs hosts (hostname: {
          publicKeyFile = ../hosts/${hostname}/ssh_host_ed25519_key.pub;
          extraHostNames = lib.optional (hostname == config.networking.hostName) "localhost";
        });
      };

      # Passwordless sudo when SSH'ing with keys
      security.pam.sshAgentAuth = {
        enable = true;
        authorizedKeysFiles = [ "/etc/ssh/authorized_keys.d/%u" ];
      };
    };
}
