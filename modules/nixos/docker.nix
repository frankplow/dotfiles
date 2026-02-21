{ config, lib, pkgs, ... }:

{
  # Enable Docker with rootless mode for security
  virtualisation.docker = {
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
    # Use btrfs storage driver (matches filesystem)
    storageDriver = "btrfs";
  };

  # Load SCSI generic driver module (required for some storage operations)
  boot.kernelModules = [ "sg" ];
}
