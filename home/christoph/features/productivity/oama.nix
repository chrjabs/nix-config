{ config, ... }:
let
  pass = "${config.programs.password-store.package}/bin/pass";
in
{
  programs.oama = {
    enable = true;
    settings = {
      encryption.tag = "KEYRING";
      services.microsoft.client_id = "9e5f94bc-e8a4-4e73-b8be-63364c29d753";
    };
  };
}
