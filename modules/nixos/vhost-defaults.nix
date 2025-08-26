# Copied from:
# https://github.com/SignalWalker/nix.nginx.vhost-defaults/blob/main/nixos-module.nix
{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
with builtins;
let
  std = pkgs.lib;
  nginx = config.services.nginx;
  mkRobotsTxt =
    robots:
    let
      agents = std.concatStringsSep "\n" (map (agent: "User-agent: ${agent}") robots);
    in
    pkgs.writeText "robots.txt" ''
      ${agents}
      Disallow: /
    '';
  regexEscapes = [
    "\""
    "["
    "]"
    "("
    ")"
    "{"
    "}"
    "^"
    "$"
    "+"
    "*"
    "."
    "|"
    "?"
    "\\"
  ];
  defaultBlockList = attrNames (fromJSON (readFile "${inputs.ai-robots-txt}/robots.json"));
in
{
  options = with lib; {
    services.nginx = {
      virtualHostDefaults = mkOption {
        type = types.deferredModuleWith {
          staticModules = [ ];
        };
        description = "Default configuration merged into every virtual host.";
        default = { };
      };
      virtualHosts = mkOption {
        # type-merge the `virtualHosts` submodule so we can import `nginx.virtualHostDefaults` into every virtualHost
        type = types.attrsOf (
          types.submoduleWith {
            # avoid conflict with default submodule declaration
            shorthandOnlyDefinesConfig = true;
            modules = [
              nginx.virtualHostDefaults
              (
                {
                  config,
                  lib,
                  ...
                }:
                {
                  options = {
                    blockAgents = {
                      enable = mkEnableOption "blocking a set of user agents from accessing this virtual host.";
                      agents = mkOption {
                        type = types.listOf types.str;
                        description = "User agent strings to block from accessing this virtual host.";
                        default = defaultBlockList;
                        defaultText = "The user agent list from [github:ai-robots-txt/ai.robots.txt](https://github.com/ai-robots-txt/ai.robots.txt).";
                        example = [
                          "Amazonbot"
                          "AI2Bot"
                          "Applebot"
                        ];
                      };
                      robotsTxt = {
                        enable = mkEnableOption "robots.txt";
                      };
                      method = mkOption {
                        type = types.str;
                        description = "Method by which to block agents.";
                        default = "return 444";
                        defaultText = "`return 444`, dropping the connection.";
                        example = "return 307 https://ash-speed.hetzner.com/10GB.bin";
                      };
                    };
                  };
                  config = lib.mkMerge [
                    (lib.mkIf (config.blockAgents.enable && (length config.blockAgents.agents) > 0) {
                      locations."= /robots.txt" = lib.mkIf config.blockAgents.robotsTxt.enable {
                        alias = mkRobotsTxt config.blockAgents.agents;
                      };
                      extraConfig =
                        let
                          agentRules = lib.concatStringsSep "|" (
                            map (lib.strings.escape regexEscapes) config.blockAgents.agents
                          );
                        in
                        ''
                          if ($http_user_agent ~* "(${agentRules})") {
                            ${config.blockAgents.method};
                          }
                        '';
                    })
                  ];
                }
              )
            ];
          }
        );
      };
    };
  };
}
