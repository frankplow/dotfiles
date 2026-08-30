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
      "/etc/NetworkManager/system-connections"
      "/var/lib/iwd"
    ];

    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
  };

  # The persisted /var/log/journal directory is owned root:root without the
  # setgid bit, so journald's files inherit group root and members of the
  # systemd-journal group cannot read the system journal (journalctl shows
  # nothing for non-root users). Re-assert the ownership/mode systemd expects so
  # new journal files inherit the systemd-journal group; the recursive rule fixes
  # the existing files too.
  systemd.tmpfiles.rules = [
    "z /var/log/journal 2755 root systemd-journal - -"
    "Z /var/log/journal/%m 2755 root systemd-journal - -"
  ];
}
