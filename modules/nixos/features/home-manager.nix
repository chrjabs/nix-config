{ inputs, ... }:
{
  flake.nixosModules.homeManager =
    { config, ... }:
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];

      home-manager = {
        useGlobalPkgs = true;
        extraSpecialArgs = {
          nixosConfig = config;
        };
      };
    };
}
