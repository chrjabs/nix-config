{
  lib,
  config,
  nixosConfig,
  ...
}:
let
  inherit (lib) mkIf;
  hasBat = config.programs.bat.enable;
  hasNeovim = config.programs.neovim.enable || config.programs.nixvim.enable;
  hasKitty = config.programs.kitty.enable;
  hasZathura = config.programs.zathura.enable;
in
{
  programs.nushell = {
    enable = true;

    shellAliases = rec {
      n = "nix";
      nd = "nom develop -c $env.SHELL";

      ll = "ls -l";
      la = "ls -la";
      cat = mkIf hasBat "bat";

      s = mkIf (nixosConfig != null) "specialisation";

      ssh = mkIf hasKitty "kitten ssh";

      vim = mkIf hasNeovim "nvim";
      vi = vim;
      v = vim;

      z = mkIf hasZathura "zathura";
    };

    extraConfig = /* nu */ ''
      $env.config = {
        edit_mode: vi,
        show_banner: false,
        use_kitty_protocol: true,
        shell_integration: {
          osc2: false,
          osc7: true,
          osc8: true,
          osc133: true,
          osc633: true,
          reset_application_mode: true,
        },
        completions: {
          algorithm: "fuzzy",
        },
        history: {
          sync_on_enter: true,
        },
      }

      source ${./completion.nu}
    '';
  };
}
