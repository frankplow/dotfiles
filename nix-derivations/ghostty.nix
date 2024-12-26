{ stdenv
, lib
, fetchurl
, _7zz
}:
  stdenv.mkDerivation rec {
    pname = "ghostty";
    version = "1.0.0";
    nativeBuildInputs = [ _7zz ];
    phases = ["unpackPhase" "installPhase"];
    src = fetchurl {
      url = "https://release.files.ghostty.org/${version}/Ghostty.dmg";
      hash = "sha256-CR96Kz9BYKFtfVKygiEku51XFJk4FfYqfXACeYQ3JlI=";
      name="${pname}-${version}.dmg";
    };
    installPhase = ''
      mkdir -p "$out/Applications/Ghostty.app"
      cp -pR * "$out/Applications/Ghostty.app"
    '';
    meta = with lib; {
      description = "Ghostty is a fast, feature-rich, and cross-platform terminal emulator that uses platform-native UI and GPU acceleration.";
      homepage = "ghostty.org";
      license = licenses.mit;
      platforms = [ "aarch64-darwin" "x86_64-darwin" ];
      mainProgram = "ghostty";
    };
  }