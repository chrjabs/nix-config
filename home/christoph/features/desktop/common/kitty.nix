{ config, ... }:
{
  # xdg.configFile."kitty/ssh.conf".text = ''
  #   share_connections no
  # '';

  xdg.mimeApps = {
    associations.added = {
      "x-scheme-handler/terminal" = "kitty.desktop";
    };
    defaultApplications = {
      "x-scheme-handler/terminal" = "kitty.desktop";
    };
  };

  home.sessionVariables.NIX_INSPECT_EXCLUDE = "kitty ncurses imagemagick";

  programs.kitty = {
    enable = true;
    keybindings = {
      "ctrl+enter" = "new_ow_window_with_cwd";
      "ctrl+shift+u" = "no_op";
      "ctrl+shift+t" = "new_tab_with_cwd";
    };
    settings = {
      editor = config.home.sessionVariables.EDITOR;
      scrollback_lines = 4000;
      scrollback_pager_history_size = 100000;
      window_padding_width = 15;
    };
  };
}
