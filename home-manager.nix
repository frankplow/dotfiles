{ config, lib, pkgs, pkgs-unstable, ... }:

{
  home.packages = with pkgs; [
    alacritty
    bat
    browserpass
    pkgs-unstable.fzf
    ghostty
    direnv
    gnupg
    htop
    ibm-plex
    obsidian
    pkgs-unstable.neovim
    net-news-wire
    pass
    pinentry_mac
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
    initExtra = ''
      autoload -z edit-command-line
      zle -N edit-command-line
      bindkey "^[e" edit-command-line

      autoload -U select-word-style
      select-word-style bash

      eval "$(direnv hook zsh)"
    '';
  };
}
