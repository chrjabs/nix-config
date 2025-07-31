{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options.specialisationScript = mkOption {
    type = types.package;
    readOnly = true;
    default =
      let
        specs = builtins.attrNames config.specialisation;
        system-path = "/nix/var/nix/profiles/system";
        specCase = spec: ''
          "${spec}")
              sudo ${system-path}/specialisation/${spec}/bin/switch-to-configuration switch
              ;;
        '';
      in
      pkgs.writeShellScriptBin "specialisation" ''
        if (( $# == 0 )); then
          echo "base"
          ${lib.concatStringsSep "\n  " (map (spec: "echo \"${spec}\"") specs)}
          exit 0
        fi

        case $1 in
          "base")
            sudo ${system-path}/bin/switch-to-configuration switch
            ;;
          ${lib.concatStringsSep "\n  " (map specCase specs)}
          *)
            >&2 echo "unknown specialisation: $1"
            ;;
        esac
      '';
  };

  config.environment.systemPackages = [ config.specialisationScript ];
}
