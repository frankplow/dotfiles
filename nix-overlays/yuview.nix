final: prev: {
  yuview = prev.yuview.overrideAttrs (oldAttrs: rec {
    version = "12a61c12401d991feab348c7c520233d604fd32d";
    patches = (oldAttrs.patches or []) ++ [ ./darwin-install-target.patch ];
    src = prev.fetchFromGitHub {
      owner = "IENT";
      repo = "YUView";
      rev = "${version}";
      sha256 = "sha256-T2xLf1PA66xLLjZbHTnoJhZxBaPcEIOLQMB+5wgNgac=";
    };
  });
}
