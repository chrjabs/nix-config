{pkgs, ...}: {
  imports = [
    ./firefox.nix
    ./fuzzel.nix
    ./gamma-step.nix
    ./gtk.nix
    ./imv.nix
    ./kitty.nix
    ./mako.nix
    ./nextcloud.nix
    ./obsidian.nix
    ./pavucontrol.nix
    ./playerctl.nix
    ./spotify.nix
    ./swayidle.nix
    ./swaylock.nix
    ./waybar.nix
    ./waypipe.nix
    ./zathura.nix
  ];

  xdg.mimeApps.enable = true;
  home.packages = with pkgs; [
    # wf-recorder
    wl-clipboard
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    QT_QPA_PLATFORM = "wayland";
    LIBSEAT_BACKEND = "logind";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };

  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-wlr];

  services.cliphist.enable = true;
}
