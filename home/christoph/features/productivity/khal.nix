{config, ...}: {
  programs.khal = {
    enable = true;
    locale = {
      timeformat = "%H:%M";
      dateformat = "%d/%m/%Y";
      weeknumbers = "left";
    };
  };

  home.persistence."/persist/${config.home.homeDirectory}".directories = [
    ".local/share/khal"
  ];
}
