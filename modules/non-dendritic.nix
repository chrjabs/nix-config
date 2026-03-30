{ inputs, ... }:
let
  outputs = inputs.self.outputs;
in
{
  flake = {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      # Laptop
      tuathaan = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          bootstrap = false;
        };
        modules = [ ../hosts/tuathaan ];
      };
      # Hetzner cloud VPS
      terangreal = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          bootstrap = false;
        };
        modules = [ ../hosts/terangreal ];
      };
      # Homeserver VM
      avendesora = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          bootstrap = false;
        };
        modules = [ ../hosts/avendesora ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "christoph@jabsserver" = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs outputs;
          workMode = false;
          nixosConfig = null;
        };
        modules = [
          ../home/christoph/jabsserver
          ../home/christoph/standalone.nix
        ];
      };
    };
  };
}
