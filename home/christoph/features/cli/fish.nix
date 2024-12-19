{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  packageNames = map (p: p.pname or p.name or null) config.home.packages;
  hasPackage = name: lib.any (x: x == name) packageNames;
  hasRipgrep = hasPackage "ripgrep";
  hasEza = hasPackage "eza";
  hasBat = config.programs.bat.enable;
  hasNeovim = config.programs.neovim.enable || config.programs.nixvim.enable;
  hasKitty = config.programs.kitty.enable;
  hasZathura = config.programs.zathura.enable;
  hasSpecialisationCli = hasPackage "specialisation";
  hasCsc = hasPackage "csc";
in {
  programs.fish = {
    enable = true;

    shellAbbrs = rec {
      n = "nix";
      nd = "nix develop -c $SHELL";

      ls = mkIf hasEza "eza";
      ll = mkIf hasEza "eza -l";
      la = mkIf hasEza "eza -la";
      cat = mkIf hasBat "bat";

      s = mkIf hasSpecialisationCli "specialisation";

      vim = mkIf hasNeovim "nvim";
      vi = vim;
      v = vim;

      z = mkIf hasZathura "zathura";

      c = mkIf hasCsc "csc";
    };

    functions = {
      # Disable greeting
      fish_greeting = "";
      interactiveShellInit =
        lib.optionalString hasKitty
        /*
        fish
        */
        ''
          # kitty integration
          set --global KITTY_INSTALLATION_DIR "${pkgs.kitty}/lib/kitty"
          set --global KITTY_SHELL_INTEGRATION enabled
          source "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_conf.d/kitty-shell-integration.fish"
          set --prepend fish_complete_path "$KITTY_INSTALLATION_DIR/shell-integration/fish/vendor_completions.d"
        ''
        +
        /*
        fish
        */
        ''
          # Use vim bindings and cursors
          fish_vi_key_bindings
          set fish_cursor_default     block      blink
          set fish_cursor_insert      line       blink
          set fish_cursor_replace_one underscore blink
          set fish_cursor_visual      block

          # Use terminal colors
          set -U fish_color_autosuggestion    brblack
          set -U fish_color_cancel            -r
          set -U fish_color_command           brgreen
          set -U fish_color_comment           brmagenta
          set -U fish_color_cwd               green
          set -U fish_color_cwd_root          red
          set -U fish_color_end               brmagenta
          set -U fish_color_error             brred
          set -U fish_color_history_current   --bold
          set -U fish_color_host              normal
          set -U fish_color_match             --background=brblue
          set -U fish_color_normal            normal
          set -U fish_color_operator          cyan
          set -U fish_color_param             brblue
          set -U fish_color_quote             yellow
          set -U fish_color_redirection       bryellow
          set -U fish_color_search_match      'bryellow' '--background=brbalck'
          set -U fish_color_selection         'white' '--bold' '--background=brblack'
          set -U fish_color_status            red
          set -U fish_color_user              brgreen
          set -U fish_color_valid_path        --underline
          set -U fish_pager_color_completion  normal
          set -U fish_pager_color_description yellow
          set -U fish_pager_color_prefix      'white' '--bold' '--underline'
          set -U fish_pager_color_progress    'brwhite' '--background=cyan'
        '';
    };
  };

  home.persistence."/persist/${config.home.homeDirectory}".files = [".local/share/fish/fish_history"];
}
