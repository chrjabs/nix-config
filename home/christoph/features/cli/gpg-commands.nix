{
  pkgs,
  lib,
  ...
}:
let
  pgrep = lib.getExe' pkgs.procps "pgrep";
  gpg-connect-agent = lib.getExe' pkgs.gnupg "gpg-connect-agent";
  grep = lib.getExe pkgs.gnugrep;
in
{
  isUnlocked = "${pgrep} 'gpg-agent' &> /dev/null && ${gpg-connect-agent} 'scd getinfo card_list' /bye | ${grep} SERIALNO -q";
}
