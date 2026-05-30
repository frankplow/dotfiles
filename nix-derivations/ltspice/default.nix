{
  lib,
  stdenvNoCC,
  fetchurl,
  # Linux-only
  msitools,
  icoutils,
  imagemagick,
  wine64,
  makeDesktopItem,
  copyDesktopItems,
  # Darwin-only
  xar,
  cpio,
  pbzx,
  makeWrapper,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ltspice";
  version = "26.0.2";

  src =
    if stdenvNoCC.hostPlatform.isDarwin then
      fetchurl {
        url = "https://ltspice.analog.com/software/LTspice_26.pkg";
        hash = "sha256-879Six3xsy0v7PjiC5K8F/5vFyP0K1J1Q8bDCclzn/I=";
      }
    else
      fetchurl {
        url = "https://ltspice.analog.com/download/${finalAttrs.version}/LTspice64.msi";
        hash = "sha256-SF2r0tfYKT3nM6OZcZ9lOO/aSlS0ixgaFOBycRhphNM=";
      };

  dontUnpack = true;
  dontConfigure = true;

  nativeBuildInputs =
    if stdenvNoCC.hostPlatform.isDarwin then
      [
        xar
        cpio
        pbzx
        makeWrapper
      ]
    else
      [
        msitools
        icoutils
        imagemagick
        copyDesktopItems
      ];

  postPatch = lib.optionalString (!stdenvNoCC.hostPlatform.isDarwin) ''
    cp ${./ltspice.sh} ./ltspice.sh
    substituteInPlace ./ltspice.sh \
      --replace-fail wine ${lib.getExe wine64} \
      --replace-fail @outpath@ $out
  '';

  buildPhase =
    if stdenvNoCC.hostPlatform.isDarwin then
      ''
        runHook preBuild
        xar -xf $src
        cd Package.pkg
        pbzx -n Payload | cpio -i
        runHook postBuild
      ''
    else
      ''
        runHook preBuild
        msiextract $src
        mv -f "APPDIR:."/* .
        mv -f "LocalAppDataFolder/LTspice"/* .
        wrestool -x -t 14 LTspice.exe | magick ICO:- ltspice.png
        rm Remove.exe updater.exe
        runHook postBuild
      '';

  installPhase =
    if stdenvNoCC.hostPlatform.isDarwin then
      ''
        runHook preInstall
        mkdir -p $out/Applications
        cp -R Applications/LTspice.app $out/Applications/
        makeWrapper $out/Applications/LTspice.app/Contents/MacOS/LTspice $out/bin/ltspice
        runHook postInstall
      ''
    else
      ''
        runHook preInstall
        mkdir -p $out
        install -Dm644 ltspice.png $out/share/icons/hicolor/256x256/apps/ltspice.png

        install -m755 -d $out/libexec/ltspice
        install -m755 *.exe $out/libexec/ltspice
        install -m655 *.zip $out/libexec/ltspice

        install -Dm755 ltspice.sh $out/bin/ltspice
        runHook postInstall
      '';

  desktopItems = lib.optionals (!stdenvNoCC.hostPlatform.isDarwin) [
    (makeDesktopItem {
      name = "ltspice";
      desktopName = "LTspice";
      comment = finalAttrs.meta.description;
      exec = "${finalAttrs.meta.mainProgram} %f";
      icon = "ltspice";
      mimeTypes = [
        "application/raw"
        "application/asc"
        "application/res"
        "application/asy"
        "application/bead"
        "application/bjt"
        "application/cap"
        "application/dio"
        "application/ind"
        "application/jft"
        "application/mos"
      ];
    })
  ];

  meta = {
    description = "SPICE simulator, schematic capture and waveform viewer";
    homepage = "https://www.analog.com/en/resources/design-tools-and-calculators/ltspice-simulator.html";
    changelog = "https://ltspice.analog.com/download/updates.txt";
    license = lib.licenses.unfree;
    mainProgram = "ltspice";
    maintainers = [ lib.maintainers.zimward ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})

# vi:sw=2:ts=2:et
