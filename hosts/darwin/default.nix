{ config, lib, pkgs, pkgs-unstable, ... }:

{
  imports = [
    ../../modules/shared/nix.nix
    ../../modules/shared/shells.nix
  ];

  # FIXME: This is needed to address bug where the $PATH is re-ordered by
  # the `path_helper` tool, prioritising Apple's tools over the ones we've
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
    shell = pkgs.fish;
    uid = 1000;
  };

  # Enable Homebrew for macOS-specific applications
  homebrew = {
    enable = true;
    casks = [
      "spotify"
      # "textual"
    ];
  };
}
