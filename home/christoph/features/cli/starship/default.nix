{
  pkgs,
  lib,
  ...
}:
{
  programs.starship = {
    enable = true;
    settings =
      let
        hostInfo = "$username$hostname($shlvl)($cmd_duration)";
        nixInfo = "($nix_shell)\${custom.nix_inspect}";
        localInfo = "$directory(\${custom.jj}\${custom.git_branch}\${custom.git_commit}\${custom.git_state}\${custom.git_status})";
        prompt = "$jobs$character";
      in
      {
        format = ''
          ${hostInfo} $fill ${nixInfo}
          ${localInfo}
          ${prompt}
        '';

        fill.symbol = " ";

        # Core
        username.format = "[$user]($style) ";
        hostname = {
          format = "[$hostname]($style) ";
          ssh_only = false;
        };
        shlvl = {
          format = "[$shlvl]($style) ";
          threshold = 2;
          repeat = true;
          disabled = false;
        };
        cmd_duration.format = "took [$duration]($style) ";

        directory.format = "[$path]($style)( [$read_only]($read_only_style)) ";
        nix_shell = {
          format = "[($name \\(develop\\) <- )$symbol]($style) ";
          impure_msg = "";
          symbol = " ";
          style = "bold red";
        };
        # Disable git modules by default. They are used via a custom module
        # below, only if we're not in a JJ repo.
        git_branch = {
          disabled = true;
          format = "[$symbol$branch(:$remote_branch)]($style) ";
        };
        git_commit.disabled = true;
        git_state.disabled = true;
        git_status.disabled = true;
        custom = {
          nix_inspect = {
            when = "test -x $IN_NIX_SHELL";
            command = lib.getExe (
              pkgs.writeShellApplication {
                name = "nix-inspect";
                runtimeInputs = with pkgs; [
                  perl
                  gnugrep
                  findutils
                ];
                text = builtins.readFile ./nix-inspect-path.sh;
              }
            );
            format = "[($output <- )$symbol]($style) ";
            symbol = " ";
            style = "bold blue";
          };
          jj = {
            when = "jj root --ignore-working-copy";
            command = "${lib.getExe' pkgs.starship-jj "starship-jj"} --ignore-working-copy starship prompt";
            ignore_timeout = true;
          };
          git_branch = {
            when = "! jj root --ignore-working-copy";
            command = "starship module git_branch";
          };
          git_commit = {
            when = "! jj root --ignore-working-copy";
            command = "starship module git_commit";
          };
          git_state = {
            when = "! jj root --ignore-working-copy";
            command = "starship module git_state";
          };
          git_status = {
            when = "! jj root --ignore-working-copy";
            command = "starship module git_status";
          };
        };

        character = {
          error_symbol = "[~~>](bold red)";
          success_symbol = "[->>](bold green)";
          vimcmd_symbol = "[<<-](bold yellow)";
          vimcmd_visual_symbol = "[<<-](bold cyan)";
          vimcmd_replace_symbol = "[<<-](bold purple)";
          vimcmd_replace_one_symbol = "[<<-](bold purple)";
        };

        # Cloud formatting
        gcloud.format = "on [$symbol$active(/$project)(\\($region\\))]($style)";
        aws.format = "on [$symbol$profile(\\($region\\))]($style)";

        aws.symbol = " ";
        conda.symbol = " ";
        dart.symbol = " ";
        directory.read_only = " ";
        docker_context.symbol = " ";
        elm.symbol = " ";
        elixir.symbol = "";
        gcloud.symbol = " ";
        git_branch.symbol = " ";
        golang.symbol = " ";
        hg_branch.symbol = " ";
        java.symbol = " ";
        julia.symbol = " ";
        memory_usage.symbol = "󰍛 ";
        nim.symbol = "󰆥 ";
        nodejs.symbol = " ";
        package.symbol = "󰏗 ";
        perl.symbol = " ";
        php.symbol = " ";
        python.symbol = " ";
        ruby.symbol = " ";
        rust.symbol = " ";
        scala.symbol = " ";
        shlvl.symbol = "";
        swift.symbol = "󰛥 ";
        terraform.symbol = "󱁢";
      };
  };
}
