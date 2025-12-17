{
  imports = [ ../../common/global/tailscale.nix ];
  services.tailscale = {
    useRoutingFeatures = "both";
    extraUpFlags = [ "--advertise-routes=192.168.1.0/24" ];
  };
}
