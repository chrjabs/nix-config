{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.wofi = {
    enable = true;

    settings = {
      image_size = 48;
      columns = 3;
      allow_images = true;
      insensitive = true;
      run-always_parse_args = true;
      run-cache_file = "/dev/null";
      run-exec_search = true;
      matching = "multi-contains";
      key_expand = "Tab";
    };
  };

  home.packages = let
    inherit (config.programs.password-store) package enable;
  in
    lib.optional enable (pkgs.pass-wofi.override {pass = package;});

  stylix.targets.wofi.enable = true;
}
