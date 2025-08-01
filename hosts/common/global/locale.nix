{ lib, ... }:
{
  i18n = {
    defaultLocale = lib.mkDefault "en_GB.UTF-8";
    supportedLocales = lib.mkDefault [
      "en_GB.UTF-8/UTF-8"
      "de_DE.UTF-8/UTF-8"
    ];
  };
  location.provider = "geoclue2";
  time.timeZone = lib.mkDefault "Europe/Helsinki";
}
