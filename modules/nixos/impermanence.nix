{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    "${inputs.impermanence}/nixos.nix"
  ];

  # Configure impermanence to persist specific files and directories
  # Root filesystem is ephemeral and wiped on boot (configured in hardware.nix)
  environment.persistence."/nix/persist" = {
    hideMounts = true;

    directories = [
      "/var/log"
      "/var/lib/nixos"
      "/var/lib/lastlog"
      "/var/lib/systemd/coredump"
      "/var/lib/systemd/timers"
    ];

    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
  };
}
