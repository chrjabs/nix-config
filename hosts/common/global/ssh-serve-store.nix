{
  nix = {
    sshServe = {
      enable = true;
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHGz8FAaHOD4lHH7c0YEcyBZkbevKAcyKRkbM65m4PfT nix-ssh"
      ];
      protocol = "ssh";
      write = true;
    };
    settings.trusted-users = [ "nix-ssh" ];
  };
}
