{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, nix-darwin, home-manager }:
  let
    cfg-module = { pkgs, pkgs-unstable, ... }: {
      environment.systemPackages = [];

      environment.shells = with pkgs; [ bashInteractive zsh fish ];
      programs.zsh.enable = true;
      programs.fish.enable = true;

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      services.karabiner-elements.enable = true;

      # The platform the configuration will be used on.
      nixpkgs = {
        hostPlatform = "aarch64-darwin";
        config.allowUnfree = true;
        overlays = [
          (import ./nix-overlays/yuview.nix)
        ];
      };

      users.users.frank = {
        home = "/Users/frank";
        shell = pkgs.fish;
      };

      homebrew = {
        enable = true;
        casks = [
          "chromium"
          "spotify"
          # "textual"
        ];
      };
    };

    # hm-module = args@{ pkgs, pkgs-unstable, lib, config, ... }: home-manager.darwinModules.home-manager
    #   ({
    #     inherit pkgs lib config;
    #     home-manager.extraSpecialArgs = { inherit pkgs-unstable; };
    #     home-manager.useGlobalPkgs = true;
    #     home-manager.useUserPackages = true;
    #     home-manager.users.frank = import ./home-manager.nix;
    #   } // args);
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake ~/.config/nix-darwin/flake.nix
    darwinConfigurations.nix-darwin = nix-darwin.lib.darwinSystem rec {
      specialArgs = {
        pkgs-unstable = import nixpkgs-unstable {
          system = "aarch64-darwin";
          config.allowUnfree = true;
        };
      };
      modules = [
        cfg-module
        # hm-module
        home-manager.darwinModules.home-manager
        {
          home-manager.extraSpecialArgs = { pkgs-unstable = specialArgs.pkgs-unstable; };
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.frank = import ./home-manager.nix;
        }
      ];
    };

    darwinPackages = self.darwinConfigurations.nix-darwin.pkgs;
  };
}
