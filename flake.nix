{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, nix-darwin, vscode-server, ... }:
  let
    # Helper function to create pkgs-unstable for a given system
    mkPkgsUnstable = system: import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };

    # Helper function to create home-manager configuration
    mkHomeManagerConfig = { system, username }: {
      home-manager.extraSpecialArgs = {
        pkgs-unstable = mkPkgsUnstable system;
      };
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${username} = import ./home-manager;
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake ~/.dotfiles
    darwinConfigurations.nix-darwin = nix-darwin.lib.darwinSystem {
      specialArgs = {
        pkgs-unstable = mkPkgsUnstable "aarch64-darwin";
        inherit inputs;
      };
      modules = [
        # Set Git commit hash for darwin-version
        { system.configurationRevision = self.rev or self.dirtyRev or null; }
        ./hosts/darwin/default.nix
        ./hosts/darwin/nix-darwin/default.nix
        home-manager.darwinModules.home-manager
        (mkHomeManagerConfig {
          system = "aarch64-darwin";
          username = "frank";
        })
      ];
    };
    darwinPackages = self.darwinConfigurations.nix-darwin.pkgs;

    # Build NixOS flake using:
    # $ nixos-rebuild build --flake ~/.dotfiles
    nixosConfigurations.dastardly = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        pkgs-unstable = mkPkgsUnstable "x86_64-linux";
        inherit inputs;
      };
      modules = [
        ./hosts/nixos/default.nix
        ./hosts/nixos/dastardly/default.nix
        home-manager.nixosModules.home-manager
        (mkHomeManagerConfig {
          system = "x86_64-linux";
          username = "frank";
        })
        vscode-server.nixosModules.default
      ];
    };
  };
}

# vi:sw=2:ts=2:et
