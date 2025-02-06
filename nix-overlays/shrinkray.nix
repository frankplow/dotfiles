final: prev: {
  shrinkray = final.callPackage ../nix-derivations/shrinkray.nix {
    python = prev.python3;
  };
}
