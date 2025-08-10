{
  environment.persistence = {
    "/persist".directories = [ "/srv/git" ];
  };

  services.gitMirror = {
    enable = true;
    dates = "hourly";
    basePath = "/srv/git";
    repos = {
      nix-config = "https://github.com/chrjabs/nix-config";
      rustsat = "https://github.com/chrjabs/rustsat";
      scuttle = "https://github.com/chrjabs/scuttle";
    };
  };
}
