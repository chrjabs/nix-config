{config, ...}: {
  imports = [
    ./global
  ];

  home = {
    homeDirectory = "/tank/home/${config.home.username}";

    persistence."/persist/${config.home.homeDirectory}".enable = false;
  };

  # No dconf
  stylix.targets = {
    gtk.enable = false;
    gnome.enable = false;
    gnome-text-editor.enable = false;
    eog.enable = false;
  };
}
