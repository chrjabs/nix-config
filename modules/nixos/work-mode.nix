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

    specialisation.work.configuration = lib.mkIf config.workMode.enable {
      # Specialisation recognition for nh
      environment.etc."specialisation".text = "work";
      home-manager.extraSpecialArgs.workMode = true;
    };
  };
}
