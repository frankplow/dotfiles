{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware.nix
    ../../../modules/nixos/impermanence.nix
    ../../../modules/nixos/docker.nix
    ../../../modules/nixos/nvidia.nix
  ];

  # Set the hostname
  networking.hostName = "dastardly";

  # Machine-specific configuration for dastardly
  # Common NixOS configuration is in ../default.nix
  # Hardware configuration is in ./hardware.nix
}
