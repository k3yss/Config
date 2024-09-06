{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };
    nbfc-linux = {
      url = "github:nbfc-linux/nbfc-linux";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      nixos-hardware,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations = {
        nixos = nixpkgs-unstable.lib.nixosSystem {

          system = "x86_64-linux";
          specialArgs = {
            inherit inputs pkgs-unstable;
          };
          modules = [
            ./configuration.nix
            nixos-hardware.nixosModules.omen-15-en1007sa
            #inputs.home-manager.nixosModules.default
            #{
            #  home-manager.extraSpecialArgs = {
            #    inherit pkgs-unstable;
            #  };
            #}
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
			  home-manager.useUserPackages = true;
			  home-manager.users.k3ys = import ./home-manager.nix;
              home-manager.extraSpecialArgs = {
                inherit inputs pkgs-unstable;
              };
              # Optionally, use home-manager.extraSpecialArgs to pass
              # arguments to home.nix
            }
          ];
        };
      };

      # homeConfigurations."k3ys" = home-manager.lib.homeManagerConfiguration {
      #   pkgs = nixpkgs.legacyPackages.${system};
      #   modules = [ ./home-manager.nix ];
      #   extraSpecialArgs = {
      #     inherit pkgs-unstable home-manager;
      #   };
      # };
    };
}
