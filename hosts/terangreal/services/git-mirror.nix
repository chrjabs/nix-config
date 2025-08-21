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
      nur-packages = "https://github.com/chrjabs/nur-packages";
      "chrjabs.github.io" = "https://github.com/chrjabs/chrjabs.github.io";
      gbd = "https://github.com/chrjabs/gbd";
      gbdc = "https://github.com/chrjabs/gbdc";
      dblp-helper = "https://github.com/chrjabs/dblp-helper";
      Grape-Academic-Theme = "https://github.com/chrjabs/Grape-Academic-Theme";
      maxpre-rs = "https://github.com/chrjabs/maxpre-rs";
      MoaMopb = "https://github.com/chrjabs/MoaMopb";
      masters-thesis = "https://github.com/chrjabs/masters-thesis";
    };
  };
}
