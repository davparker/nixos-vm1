{
  description = "Starter NixOS system flake with Home Manager";

  inputs = {
    # Nixpkgs channel (switch to nixos-24.11 / nixos-25.05 / nixos-unstable as needed)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";

    # Home Manager follows nixpkgs so versions and packages match exactly
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.nixos-vm1 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hardware-configuration.nix
        ./configuration.nix

        # Include Home Manager as a NixOS module
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.david = import ./home.nix;
        }
      ];
    };
  };
}
