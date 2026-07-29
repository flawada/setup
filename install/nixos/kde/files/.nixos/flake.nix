{
  description = "flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
  };

  outputs = { self, nixpkgs, home-manager, nix-cachyos-kernel }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      modules = [
        {
          nixpkgs.overlays = [ nix-cachyos-kernel.overlays.pinned ];
        }
        ./configuration.nix
        home-manager.nixosModules.home-manager
      ];
    };
  };

}
