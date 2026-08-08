{ config, lib, pkgs, pkgs-unstable, ... }:

{
  imports = [
    ../../modules/shared/nix.nix
    ../../modules/shared/shells.nix
    ../../kanata/default.nix
  ];

  # Auto upgrade nix package and the daemon service
  nix.enable = true;

  # Set Git commit hash for darwin-version
  # Note: This is set in flake.nix via specialArgs

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # Kanata keyboard remapper
  services.kanata = {
    enable = true;
    package = pkgs-unstable.kanata;
    keyboards.default.configFile = "/Users/frank/.dotfiles/kanata/kanata.kbd";
  };

  # The platform the configuration will be used on
  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config.permittedInsecurePackages = [
      "electron-39.8.10"
    ];
    overlays = [
      # karabiner-elements pinned to 14.13.0 pending resolution of
      # https://github.com/LnL7/nix-darwin/issues/1041
      (import ../../nix-overlays/clockify.nix)
      (import ../../nix-overlays/karabiner-elements.nix)
      (import ../../nix-overlays/ltspice.nix)
      (import ../../nix-overlays/ssh-agent-mux.nix)
      (import ../../nix-overlays/yuview.nix)
      (import ../../nix-overlays/zulip.nix)
    ];
  };

  # Configure primary user
  system.primaryUser = "frank";
  users.users.frank = {
    home = "/Users/frank";
    shell = pkgs.zsh;
    uid = 501;
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
