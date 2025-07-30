{ config, ... }:
{
  programs.khal = {
    enable = true;
    locale = rec {
      timeformat = "%H:%M";
      dateformat = "%d.%m.";
      longdateformat = "%d.%m.%Y";
      datetimeformat = "${dateformat} ${timeformat}";
      longdatetimeformat = "${longdateformat} ${timeformat}";
      weeknumbers = "left";
    };
  };

  home.persistence."/persist/${config.home.homeDirectory}".directories = [
    ".local/share/khal"
  ];
}
