{
  flake.nixosModules.base =
    { pkgs, ... }:
    {
      users.mutableUsers = false;

      services.upower.enable = true;

      environment = {
        systemPackages = [ pkgs.kitty.terminfo ];
      };

      styling.enable = true;
    };
}
