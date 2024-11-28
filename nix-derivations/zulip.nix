{ stdenv
, lib
, fetchurl
, _7zz
}:
  stdenv.mkDerivation rec {
    pname = "zulip";
    version = "5.11.1";
    nativeBuildInputs = [ _7zz ];
    phases = ["unpackPhase" "installPhase"];
    src = fetchurl {
      url = "https://github.com/zulip/zulip-desktop/releases/download/v${version}/Zulip-${version}-arm64.dmg";
      hash = "sha256-0sBGI2GrH4oPjQM30q0cJNbA/yTPhbR294Z6MoQ6bt8=";
      name="${pname}-${version}.dmg";
    };
    installPhase = ''
      mkdir -p "$out/Applications/Zulip.app"
      cp -pR * "$out/Applications/Zulip.app"
    '';
    meta = with lib; {
      description = "Desktop client for Zulip Chat";
      homepage = "https://zulip.com";
      license = licenses.asl20;
      platforms = [ "aarch64-darwin" ];
      mainProgram = "zulip";
    };
  }

# let
#   pname = "zulip";
#   version = "5.11.1";

#   src = fetchurl {
#     url = "https://github.com/zulip/zulip-desktop/releases/download/v${version}/Zulip-${version}-arm64.dmg";
#     hash = "sha256-t5qBm5+kTdeRMvcHpNbS5mp184UG/IqgJrtj7Ntcbb0=";
#     name="${pname}-${version}.AppImage";
#   };

#   appimageContents = appimageTools.extractType2 {
#     inherit pname version src;
#   };

# in appimageTools.wrapType2 {
#   inherit pname version src;

#   runScript = "appimage-exec.sh -w ${appimageContents} -- \${NIXOS_OZONE_WL:+\${WAYLAND_DISPLAY:+--ozone-platform-hint=auto}}";

#   extraInstallCommands = ''
#     install -m 444 -D ${appimageContents}/zulip.desktop $out/share/applications/zulip.desktop
#     install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/zulip.png \
#       $out/share/icons/hicolor/512x512/apps/zulip.png
#     substituteInPlace $out/share/applications/zulip.desktop \
#       --replace-fail 'Exec=AppRun' 'Exec=${pname}'
#   '';

#   meta = with lib; {
#     description = "Desktop client for Zulip Chat";
#     homepage = "https://zulip.com";
#     license = licenses.asl20;
#     maintainers = with maintainers; [ andersk ];
#     platforms = [ "aarch64-darwin" ];
#     mainProgram = "zulip";
#   };
# }
