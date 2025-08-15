{ pkgs, config, ... }:
{
  services.github-runners =
    let
      common = name: {
        enable = true;
        ephemeral = true;
        url = "https://github.com/chrjabs/rustsat";
        tokenFile = config.sops.secrets.github-runner-token.path;
        extraLabels = [
          "nix"
          "nixos"
        ];
        extraPackages = with pkgs; [
          git
          gh
          jq
          curl
          gnused
          gnugrep
          gawk
        ];
      };
      hostname = config.networking.hostName;
    in
    {
      "${hostname}-1" = common "${hostname}-1";
      "${hostname}-2" = common "${hostname}-2";
    };

  sops.secrets.github-runner-token.sopsFile = ../secrets.yaml;

  # workDir for workers is under `/run` and we need a bit more space
  boot.runSize = "50%";
}
