{ config, lib, pkgs, ... }:

{
  # Enable NVIDIA proprietary drivers
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics.enable = true;
  hardware.nvidia.open = false;

  # Configure CUDA binary cache for faster CUDA builds
  nix.settings = {
    substituters = [
      "https://cache.nixos-cuda.org"
    ];
    trusted-public-keys = [
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
    ];
  };
}
