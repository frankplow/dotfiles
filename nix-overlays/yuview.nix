final: prev: {
  libsForQt5 = prev.libsForQt5.overrideScope (qt5final: qt5prev: {
    yuview = qt5prev.yuview.overrideAttrs (oldAttrs: rec {
      version = "2.14";
      patches = (oldAttrs.patches or []) ++ [ ./darwin-install-target.patch ];
      src = prev.fetchFromGitHub {
        owner = "IENT";
        repo = "YUView";
        rev = "v${version}";
        sha256 = "sha256-YuKPRYBr1CKrwickk1T89ZCYFt99jP86tdanp+JZMO4=";
      };
    });
  });
}
