{
  flake.homeModules.base =
    {
      lib,
      config,
      workMode ? false,
      ...
    }:
    {
      home = {
        username = lib.mkDefault "christoph";
        homeDirectory = lib.mkDefault "/home/${config.home.username}";
        sessionVariables.NH_FLAKE = lib.mkDefault "github:chrjabs/nix-config";

        # persistence = {
        #   "/persist" = {
        #     directories = [
        #       "Documents"
        #       "Downloads"
        #       "Pictures"
        #       "Videos"
        #       ".local/bin"
        #       ".local/share/nix" # trusted settings and repl history
        #       ".cache/nix"
        #     ]
        #     ++ lib.optionals workMode [
        #       "Work"
        #     ];
        #   };
        # };
      };
    };
}
