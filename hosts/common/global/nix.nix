{
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      flake-registry = ""; # Disable global flake registry
      warn-dirty = false;
    };
  };

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 4d --keep 3";
    };
  };
}
