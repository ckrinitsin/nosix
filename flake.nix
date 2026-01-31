{
  description = "Nosix Server Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    colmena.url = "github:zhaofengli/colmena";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, colmena }: {
    nixosConfigurations = {
      nosix = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          unstable = import nixpkgs-unstable {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
        };
        modules = [ ./configuration.nix ./hardware-configuration.nix ];
      };
    };

    colmena = {
      meta = {
        nixpkgs = import nixpkgs { system = "x86_64-linux"; };
        specialArgs = {
          unstable = import nixpkgs-unstable {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
        };
      };

      nosix = { name, nodes, ... }: {
        deployment = {
          targetHost = "krinitsin.com";
          targetUser = "root";
        };

        imports = [ ./configuration.nix ./hardware-configuration.nix ];
      };
    };

  };
}
