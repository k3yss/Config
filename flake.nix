{
  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
	nixos-hardware = {
		url = "github:NixOS/nixos-hardware/master";
	};
    nbfc-linux = {
      url = "github:nbfc-linux/nbfc-linux";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
  };
  outputs = { self, nixpkgs, nixpkgs-stable, nixos-hardware, home-manager, ... } @inputs: 
  let 
  system = "x86_64-linux";
  pkgs-unstable = import nixpkgs {
	  inherit system;
	  config.allowUnfree = true;
  };
  in
  {
    nixosConfigurations.nixos = nixpkgs-stable.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs pkgs-unstable; };
      modules = [
        ./configuration.nix
        nixos-hardware.nixosModules.omen-15-en1007sa
		inputs.home-manager.nixosModules.default {
            home-manager.extraSpecialArgs = { inherit pkgs-unstable; };
          }
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit (self) inputs outputs; };
          # Optionally, use home-manager.extraSpecialArgs to pass
          # arguments to home.nix
        }
      ];
    };
  };
}
