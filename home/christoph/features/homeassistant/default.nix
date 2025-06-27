{
  pkgs,
  lib,
  ...
}: {
  home.packages = let
    lamp = pkgs.writeShellScriptBin "lamp" ''
      ${lib.getExe pkgs.curl} \
        -H "Authorization: Bearer $(cat /run/secrets/ha-api-token)" \
        -H "Content-Type: application/json" \
        -d '{"entity_id": "light.desk_lamp_christoph_light", "brightness_pct": '"$1"'}' \
        -s -o /dev/null \
        https://home.jabsserver.net:8123/api/services/light/turn_on
    '';
  in [
    lamp
  ];
}
