{ config, lib, pkgs, pkgs-unstable, ... }:

{
  imports = [
    ../../modules/shared/nix.nix
    ../../modules/shared/shells.nix
  ];

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.mutableUsers = false;
  users.defaultUserShell = pkgs.zsh;
  users.users.frank = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable sudo
    initialHashedPassword = "$6$48pOH4dFViMVqfe/$G2AprxUueKf3HuzKmRb46w4w47qjRMMkpgwFPrP0H.jylC55v5eEdAaVk75y32A4Ne9OhssEKnxLnp14pGgY20";
  };

  # Use the systemd-boot EFI boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone
  time.timeZone = "Europe/London";

  # Enable the OpenSSH daemon
  services.openssh.enable = true;

  # NFS support
  boot.supportedFilesystems = [ "nfs" ];
  services.rpcbind.enable = true;

  # Disable firewall (adjust for your security requirements)
  networking.firewall.enable = false;

  # Enable VS Code Server for remote development
  services.vscode-server.enable = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
