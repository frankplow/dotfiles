{ lib
, stdenvNoCC
, fetchurl
, unzip
, makeBinaryWrapper
}:

stdenvNoCC.mkDerivation rec {
  pname = "clockify";
  version = "2.12.2";

  src = fetchurl {
    url = "https://web.archive.org/web/20260302082903/https://clockify.me/downloads/ClockifyDesktop.zip";
    hash = "sha256-HwIW+W7NZnDoMkhpIZ92WFW58RXB8TaRS09Xeo5/YtY=";
    name = "${pname}-${version}.zip";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    unzip
    makeBinaryWrapper
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/Applications"
    cp -R "Clockify Desktop.app" "$out/Applications/"
    mkdir -p "$out/bin"
    makeWrapper "$out/Applications/Clockify Desktop.app/Contents/MacOS/Clockify Desktop" \
      "$out/bin/clockify"
    runHook postInstall
  '';

  meta = {
    description = "Free time tracker and timesheet app that lets you track work hours across projects";
    mainProgram = "clockify";
    homepage = "https://clockify.me";
    license = lib.licenses.unfree;
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
