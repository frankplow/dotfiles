{ config, lib, pkgs, pkgs-unstable, ... }:

{
  home.packages = with pkgs; [
    alacritty
    bat
    pkgs-unstable.fzf
    ghostty
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
    zulip
  ];
  home.stateVersion = "24.05";

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    historySubstringSearch.enable = true;
    syntaxHighlighting.enable = true;
    plugins = [
      {
        name = "prompt";
        src = ./zsh/prompt;
      }
      {
        name = "aliases";
        src = ./zsh/aliases;
      }
    ];
    sessionVariables = rec {
      VISUAL = "nvim";
      EDITOR = VISUAL;
      PAGER = "bat -p";
      BROWSER = "firefox";
      DIFFPROG = "nvim -d";
    };
  };
}
