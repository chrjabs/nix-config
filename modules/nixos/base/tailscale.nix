{
  flake.nixosModules.base =
    { lib, ... }:
    {
      services.tailscale = {
        enable = true;
        useRoutingFeatures = lib.mkDefault "client";
      };
      networking.firewall.allowedUDPPorts = [ 41641 ]; # Facilitate firewall punching

      persistence.directories = [ "/var/lib/tailscale" ];
    };
}
