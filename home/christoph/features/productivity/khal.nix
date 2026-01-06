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

  home.persistence."/persist".directories = [
    ".local/share/khal"
  ];

  # Set as default calendar handler
  xdg.mimeApps = {
    associations.added = {
      "text/calendar" = "khal.desktop";
    };
    defaultApplications = {
      "text/calendar" = "khal.desktop";
    };
  };
}
