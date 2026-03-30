{
  flake.nixosModules.base =
    { lib, ... }:
    {
      options.persistence = {
        enable = lib.mkEnableOption "enable persistence";

        nukeRoot = lib.mkEnableOption "Destroy `/root` on every boot";

        directories = lib.mkOption {
          default = [ ];
          description = ''
            directories to persist
          '';
        };

        files = lib.mkOption {
          default = [ ];
          description = ''
            files to persist
          '';
        };
      };
    };
}
