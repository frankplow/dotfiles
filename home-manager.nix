{ config, lib, pkgs, pkgs-unstable, ... }:

{
  home.packages = with pkgs; [
    alacritty
    bat
    pkgs-unstable.fzf
    htop
    ibm-plex
    obsidian
    pkgs-unstable.neovim
    net-news-wire
    raycast
    rectangle
    ripgrep
    libsForQt5.yuview
    pkgs-unstable.zotero
  ];
  home.stateVersion = "24.05";
}
