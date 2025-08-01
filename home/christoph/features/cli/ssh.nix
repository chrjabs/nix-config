{
  outputs,
  lib,
  config,
  workMode,
  ...
}:
let
  nixosConfigs = builtins.attrNames outputs.nixosConfigurations;
  homeConfigs = map (n: lib.last (lib.splitString "@" n)) (
    builtins.attrNames outputs.homeConfigurations
  );
  hostnames = lib.unique (homeConfigs ++ nixosConfigs);
in
{
  programs.ssh = {
    enable = true;
    userKnownHostsFile = "~/.ssh/known_hosts.d/hosts";
    matchBlocks = rec {
      own = {
        host = lib.concatStringsSep " " hostnames;
        forwardAgent = true;
        remoteForwards = [
          {
            bind.address = ''/%d/.gnupg-sockets/S.gpg-agent'';
            host.address = ''/%d/.gnupg-sockets/S.gpg-agent.extra'';
          }
          {
            bind.address = ''/%d/.waypipe/server.sock'';
            host.address = ''/%d/.waypipe/client.sock'';
          }
        ];
        forwardX11 = true;
        forwardX11Trusted = true;
        setEnv.WAYLAND_DISPLAY = "wayland-waypipe";
        extraOptions.StreamLocalBindUnlink = "yes";
      };
      "vps.jabsserver" = lib.hm.dag.entryBefore [ "jabsserver" ] {
        hostname = "portmapper.jabsserver.net";
        user = "root";
      };
      jabsserver = {
        hostname = "jabsserver.net";
        proxyJump = "vps.jabsserver";
      };
      jabsserver-tunnel = lib.hm.dag.entryBefore [ "jabsserver" ] (
        {
          dynamicForwards = [ { port = 8080; } ];
        }
        // jabsserver
      );
    }
    // lib.optionalAttrs workMode {
      uh = lib.hm.dag.entryBefore [ "melkki" "melkinkari" "turso" "turso01" "turso02" "turso03" ] {
        host = "*.helsinki.fi melkki melkinkari turso*";
        user = "chrisjab";
      };
      melkki = lib.hm.dag.entryBefore [ "turso" "turso01" "turso02" "turso03" ] {
        hostname = "melkki.cs.helsinki.fi";
      };
      melkinkari = {
        hostname = "melkinkari.cs.helsinki.fi";
      };
      turso = {
        hostname = "turso.cs.helsinki.fi";
        proxyJump = "melkki";
      };
      turso01 = {
        hostname = "turso01.cs.helsinki.fi";
        proxyJump = "melkki";
      };
      turso02 = {
        hostname = "turso02.cs.helsinki.fi";
        proxyJump = "melkki";
      };
      turso03 = {
        hostname = "turso03.cs.helsinki.fi";
        proxyJump = "melkki";
      };
    };
  };

  home.persistence = {
    "/persist/${config.home.homeDirectory}".directories = [
      ".ssh/known_hosts.d"
    ];
  };
}
