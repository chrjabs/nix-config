{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption;
in
{
  options.workMode.enable = mkEnableOption "work specialisation";

  config = {
    home-manager.extraSpecialArgs = {
      workMode = false;
    };

    specialisation = lib.mkIf config.workMode.enable {
      work.configuration = {
        # Specialisation recognition for nh
        environment.etc."specialisation".text = "work";
        home-manager.extraSpecialArgs.workMode = true;
      };
    };
  };
}
