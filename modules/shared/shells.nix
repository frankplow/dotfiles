{ config, lib, pkgs, ... }:

{
  # Make bash, zsh, and fish available as login shells
  environment.shells = with pkgs; [ bashInteractive zsh fish ];

  # Enable zsh but disable system-wide completions for performance
  # Completions are configured via home-manager instead
  # See: https://github.com/nix-community/home-manager/issues/108
  programs.zsh = {
    enable = true;
    enableCompletion = false;
    enableBashCompletion = false;
  };

  # Enable fish shell
  programs.fish.enable = true;
}
