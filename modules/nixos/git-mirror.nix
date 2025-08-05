{
  lib,
  pkgs,
  config,
  ...
}:
{
  options.services.gitMirror = {
    enable = lib.mkEnableOption "git mirror service";
    dates = lib.mkOption {
      type = lib.types.str;
      default = "04:40";
      example = "daily";
    };
    user = lib.mkOption {
      description = "User to run the mirroring service as.";
      type = lib.types.str;
      default = "git";
    };
    basePath = lib.mkOption {
      description = "The base path of where the repos should be mirrored.";
      example = "/srv/git";
    };
    repos = lib.mkOption {
      description = "repositories to mirror";
      type = with lib.types; attrsOf str;
      default = { };
      example = {
        bla = "https://github.com/<org>/<repo>";
      };
    };
  };

  config =
    let
      cfg = config.services.gitMirror;
    in
    lib.mkIf cfg.enable {
      systemd.user.services.git-mirror = {
        enable = true;
        description = "Git mirroring service";
        unitConfig.ConditionUser = cfg.user;
        serviceConfig.Type = "oneshot";
        startAt = cfg.dates;
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];

        path = with pkgs; [
          git
        ];

        script = ''
          pushd ${cfg.basePath}

          declare -A remotes
          ${lib.concatStringsSep "\n" (
            lib.attrsets.mapAttrsToList (name: remote: "remotes[\"${name}\"]=\"${remote}\"") cfg.repos
          )}

          for repo in "''${!remotes[@]}"; do
            if [ -d "$repo" ]; then
              pushd "$repo"
              git remote update
              popd
            else
              git clone --mirror -- "''${remotes[$repo]}" "$repo"
            fi
          done
        '';
      };

      # Ensure user exists
      users.users.git = { };
    };
}
