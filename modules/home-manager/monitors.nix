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
  options.monitors = {
    layouts = mkOption {
      type = types.attrsOf (
        types.attrsOf (
          types.nullOr (
            types.submodule {
              options = {
                enabled = mkOption {
                  type = types.bool;
                  default = true;
                };
                primary = mkOption {
                  type = types.bool;
                  default = false;
                };
                mode = mkOption {
                  type = types.nullOr (
                    types.submodule {
                      options = {
                        x = mkOption {
                          type = types.int;
                        };
                        y = mkOption {
                          type = types.int;
                        };
                        rate = mkOption {
                          type = types.nullOr types.float;
                          default = null;
                        };
                      };
                    }
                  );
                  default = null;
                };
                scale = mkOption {
                  type = types.nullOr types.float;
                  default = null;
                };
                position = mkOption {
                  type = types.nullOr (
                    types.submodule {
                      options = {
                        x = mkOption {
                          type = types.int;
                        };
                        y = mkOption {
                          type = types.int;
                        };
                      };
                    }
                  );
                  default = null;
                };
                rotation = mkOption {
                  type = types.nullOr types.int;
                  default = null;
                };
                workspaces = mkOption {
                  type = types.listOf types.str;
                  default = [ ];
                };
                fallback = mkOption {
                  type = types.nullOr types.str;
                  default = null;
                };
              };
            }
          )
        )
      );
      default = {
        default = null;
      };
    };

    # NOTE: this only updates the layout of the outputs, not how the workspaces are assigned to the outputs
    swayLayoutsScript = mkOption {
      type = types.package;
      readOnly = true;
      default =
        let
          swaymsg = lib.getExe' config.wayland.windowManager.sway.package "swaymsg";
          outputCmd =
            name: m:
            "${swaymsg} output \"${name}\""
            + (lib.optionalString m.enabled " enable")
            + (lib.optionalString (!m.enabled) " disable")
            + (lib.optionalString (m.mode != null) (
              " mode ${toString m.mode.x}x${toString m.mode.y}"
              + lib.optionalString (m.mode.rate != null) "@${toString m.mode.rate}Hz"
            ))
            + (lib.optionalString (m.scale != null) " scale ${toString m.scale}")
            + (lib.optionalString (
              m.position != null
            ) " position ${toString m.position.x} ${toString m.position.y}")
            + (lib.optionalString (m.rotation != null) " rotation ${toString m.rotation}");
          workspaceCmds =
            name: m:
            (builtins.map (
              w:
              "${swaymsg} move workspace \"${w}\" output \"${name}\"${
                lib.optionalString (m.fallback != null) " \"${m.fallback}\""
              }"
            ) m.workspaces);
          layoutCase = name: layout: ''
            "${name}")
                ${lib.concatStringsSep "\n    " (lib.mapAttrsToList outputCmd layout)}
                ${lib.concatStringsSep "\n    " (lib.flatten (lib.mapAttrsToList workspaceCmds layout))}
                ;;
          '';
        in
        pkgs.writeShellScriptBin "monitor-layouts" ''
          if (( $# == 0 )); then
            ${lib.concatStringsSep "\n  " (
              lib.mapAttrsToList (name: _: "echo ${name}") (
                lib.filterAttrs (_: l: l != null) config.monitors.layouts
              )
            )}
            exit 0
          fi

          case $1 in
            ${lib.concatStringsSep "\n  " (
              lib.mapAttrsToList layoutCase (lib.filterAttrs (_: l: l != null) config.monitors.layouts)
            )}
            *)
              >&2 echo "unknown monitor layout: $1"
              ;;
          esac
        '';
    };
  };
}
