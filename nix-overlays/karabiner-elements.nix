self: super: {
  karabiner-elements = super.karabiner-elements.overrideAttrs (old: {
    version = "15.5.0";

    src = super.fetchurl {
      inherit (old.src) url;
      hash = "sha256-96NQxmnU1W/g2O1Ll7qsslclFzsBPnHDJ+hmNpaUUXA=";
    };
  });
}
