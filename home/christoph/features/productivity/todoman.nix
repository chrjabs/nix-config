{ pkgs, ... }:
{
  home.packages = with pkgs; [ todoman ];

  xdg.configFile."todoman/config.py".text =
    # python
    ''
      path = "~/Calendars/nextcloud/*"
      default_list = "Christoph"
      date_format = "%d/%m/%Y"
      time_format = "%H:%M"
      humanize = True
      default_due = 0
    '';
}
