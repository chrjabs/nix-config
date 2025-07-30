{lib, ...}: {
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      flake-registry = ""; # Disable global flake registry
      warn-dirty = false;
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
  };

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 90d --keep 3";
    };
  };
}
