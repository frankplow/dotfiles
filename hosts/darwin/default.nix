{ config, lib, pkgs, pkgs-unstable, ... }:

{
  imports = [
    ../../modules/shared/nix.nix
    ../../modules/shared/shells.nix
  ];

  # Auto upgrade nix package and the daemon service
  nix.enable = true;

  # Set Git commit hash for darwin-version
  # Note: This is set in flake.nix via specialArgs

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # Enable Karabiner Elements for keyboard customization
  services.karabiner-elements.enable = true;

  # The platform the configuration will be used on
  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    overlays = [
      (import ../../nix-overlays/mi-code.nix)
      # karabiner-elements pinned to 14.13.0 pending resolution of
      # https://github.com/LnL7/nix-darwin/issues/1041
      (import ../../nix-overlays/karabiner-elements.nix)
      (import ../../nix-overlays/yuview.nix)
      (import ../../nix-overlays/zulip.nix)
    ];
  };

  # Configure primary user
  system.primaryUser = "frank";
  users.users.frank = {
    home = "/Users/frank";
    shell = pkgs.zsh;
    uid = 1000;
  };

  # Enable Homebrew for macOS-specific applications
  homebrew = {
    enable = true;
    casks = [
      "spotify"
      # "textual"
      "zoom"
    ];
  };
}
