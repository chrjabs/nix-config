{
  perSystem =
    { ... }:
    {
      treefmt = {
        settings = {
          global.on-unmatched = "error";
          formatter.shellcheck.options = [ "--shell=bash" ];
        };
        programs = {
          # Nix
          deadnix.enable = true;
          nixfmt.enable = true;
          # Shell
          shellcheck = {
            enable = true;
            excludes = [ ".envrc" ];
          };
          shfmt.enable = true;
          # TOML
          taplo.enable = true;
          # YAML
          actionlint.enable = true;
          yamlfmt = {
            enable = true;
            excludes = [
              ".sops.yaml"
              "**/*secrets.yaml"
            ];
          };
          # Sorting lists
          keep-sorted.enable = true;
        };
      };
    };
}
