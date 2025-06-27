{pkgs ? import <nixpkgs> {}, ...}: {
  default = let
    deploy =
      pkgs.writeScriptBin "deploy"
      /*
      bash
      */
      ''
        hosts="$1"
        shift

        if [ -z "$hosts" ]; then
            echo "No hosts to deploy"
            exit 2
        fi

        for host in ''${hosts//,/ }; do
            ${pkgs.lib.getExe pkgs.nixos-rebuild} --flake .\#$host switch --target-host $host --use-remote-sudo
        done
      '';
  in
    pkgs.mkShell
    {
      NIX_CONFIG = "extra-experimental-features = nix-command flakes";
      nativeBuildInputs = with pkgs; [
        nix
        home-manager
        git

        sops
        ssh-to-age
        gnupg
        age

        deploy

        deadnix
      ];
    };
}
