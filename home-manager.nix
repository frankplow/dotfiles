{ config, lib, pkgs, pkgs-unstable, ... }:

{
  home.packages = with pkgs; [
    alacritty
    net-news-wire
    raycast
    ripgrep
    libsForQt5.yuview
    pkgs-unstable.zotero
  ];
  home.stateVersion = "24.05";
}
