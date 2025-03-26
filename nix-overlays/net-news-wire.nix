self: super: {
  net-news-wire = super.net-news-wire.overrideAttrs (old: {
    version = "6.1.9";

    src = super.fetchurl {
      inherit (old.src) url;
      hash = "sha256-dNdbniXGre8G2/Ac0GB3GHJ2k1dEiHmAlTX3dJOEC7s=";
    };
  });
}
