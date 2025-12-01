{ config, lib, pkgs, pkgs-unstable, ... }:

{
  home.packages = with pkgs; [
    alacritty
    bat
    browserpass
    fzf
    ghostty-bin
    gnupg
    htop
    ibm-plex
    obsidian
    neovim
    net-news-wire
    pass
    pinentry_mac
    raycast
    rectangle
    ripgrep
    yuview
    zotero
    zulip
  ];
  home.stateVersion = "24.05";

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    config = {
      hide_env_diff = true;
    };
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    historySubstringSearch.enable = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "emacs";
    plugins = [
      {
        name = "zsh-fzf-history-search";
        src = pkgs.zsh-fzf-history-search;
        file = "share/zsh-fzf-history-search/zsh-fzf-history-search.plugin.zsh";
      }
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

      ZSH_FZF_HISTORY_SEARCH_EVENT_NUMBERS = 0;
      ZSH_FZF_HISTORY_SEARCH_DATES_IN_SEARCH = 0;
      ZSH_FZF_HISTORY_SEARCH_REMOVE_DUPLICATES = 1;
    };
    initContent = ''
      autoload -z edit-command-line
      zle -N edit-command-line
      bindkey "^[e" edit-command-line

      autoload -U select-word-style
      select-word-style bash
    '';
  };

  imports = [
    firefox/firefox.nix
  ];
}
