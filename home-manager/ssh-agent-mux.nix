{ config, lib, pkgs, ... }:

lib.mkIf pkgs.stdenv.isDarwin {
  xdg.configFile."ssh-agent-mux/ssh-agent-mux.toml".text = ''
    agent_sock_paths = [
      "~/.bitwarden-ssh-agent.sock",
      "~/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh",
    ]
    listen_path = "~/.ssh/ssh-agent-mux.sock"
  '';

  launchd.agents.ssh-agent-mux = {
    enable = true;
    config = {
      Label = "ssh-agent-mux";
      ProgramArguments = [ "${pkgs.ssh-agent-mux}/bin/ssh-agent-mux" ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "${config.home.homeDirectory}/Library/Logs/ssh-agent-mux.out";
      StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/ssh-agent-mux.err";
    };
  };
}

# vi:sw=2:ts=2:et
