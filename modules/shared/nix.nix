{ config, lib, pkgs, ... }:

{
  # Enable Nix flakes and nix-command
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Automatically deduplicate identical files in the Nix store
  nix.optimise.automatic = true;

  # Allow installation of unfree packages (e.g., NVIDIA drivers, VS Code)
  nixpkgs.config.allowUnfree = true;
}
