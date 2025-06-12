{config, ...}: {
  services.mako = {
    enable = true;
    settings = {
      padding = "10,20";
      anchor = "top-center";
      width = 400;
      height = 150;
      border-size = 2;
      default-timeout = 12000;
      layer = "overlay";
      max-history = 50;
      "mode=do-not-disturb" = {
        invisible = 1;
      };
    };
  };
}
