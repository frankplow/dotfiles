{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, nix-darwin, home-manager }:
  let
    cfg-module = { pkgs, pkgs-unstable, lib, ... }: {
      environment.systemPackages = [];

      environment.shells = with pkgs; [ bashInteractive zsh fish ];
      programs.zsh = rec {
        enable = true;
        # Disable system-wide completions for speed because we configure zsh using
        # home-manager.  See https://github.com/nix-community/home-manager/issues/108
        enableCompletion = false;
        enableBashCompletion = enableCompletion;
      };
      programs.fish.enable = true;
      # FIXME: This is needed to address bug where the $PATH is re-ordered by
      # the `path_helper` tool, prioritising Apple’s tools over the ones we’ve
      # installed with nix.
      #
      # This gist explains the issue in more detail: https://gist.github.com/Linerre/f11ad4a6a934dcf01ee8415c9457e7b2
      # There is also an issue open for nix-darwin: https://github.com/LnL7/nix-darwin/issues/122
      programs.fish.loginShellInit =
        let
          # We should probably use `config.environment.profiles`, as described in
          # https://github.com/LnL7/nix-darwin/issues/122#issuecomment-1659465635
          # but this takes into account the new XDG paths used when the nix
          # configuration has `use-xdg-base-directories` enabled. See:
          # https://github.com/LnL7/nix-darwin/issues/947 for more information.
          profiles = [
            "/etc/profiles/per-user/$USER" # Home manager packages
            "$HOME/.nix-profile"
            "(set -q XDG_STATE_HOME; and echo $XDG_STATE_HOME; or echo $HOME/.local/state)/nix/profile"
            "/run/current-system/sw"
            "/nix/var/nix/profiles/default"
          ];

          makeBinSearchPath =
            lib.concatMapStringsSep " " (path: "${path}/bin");
        in
        ''
          # Fix path that was re-ordered by Apple's path_helper
          fish_add_path --move --prepend --path ${makeBinSearchPath profiles}
          set fish_user_paths $fish_user_paths
        '';

      # Auto upgrade nix package and the daemon service.
      nix.enable = true;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Automatically deduplicate items in the store.
      nix.optimise.automatic = true;

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
          # karabiner-elements pinned to 14.13.0 pending resolution of
          # https://github.com/LnL7/nix-darwin/issues/1041
          (import ./nix-overlays/karabiner-elements.nix)
          (import ./nix-overlays/yuview.nix)
          (import ./nix-overlays/zulip.nix)
        ];
      };

      system.primaryUser = "frank";
      users.users.frank = {
        home = "/Users/frank";
        shell = pkgs.fish;
      };

      homebrew = {
        enable = true;
        casks = [
          "spotify"
          # "textual"
        ];
      };
    };

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
