{ inputs, ... }:
{
  flake.overlays.modifications = final: prev: {
    # https://github.com/mdellweg/pass_secret_service/pull/37
    pass-secret-service = prev.pass-secret-service.overrideAttrs (oldAttrs: {
      patches = (oldAttrs.patches or [ ]) ++ [ ./pass-secret-service-native.diff ];
    });

    # Make sure to use the home-manager executable from the home-manager input
    inherit (inputs.home-manager.packages.${final.stdenv.hostPlatform.system}) home-manager;
  };
}
