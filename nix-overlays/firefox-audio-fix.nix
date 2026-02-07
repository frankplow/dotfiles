# Overlay to fix Firefox audio codec issues on macOS
# See: https://github.com/NixOS/nixpkgs/issues/462923
#
# The issue is that the Firefox wrapper symlinks Mach-O shared libraries
# instead of copying them. This causes audio/video codec loading to fail
# when running from the Nix store. The fix is to copy all Mach-O shared
# libraries, not just *.dylib files.

final: prev:

let
  patchFirefoxWrapper = drv: drv.overrideAttrs (oldAttrs: {
    buildCommand =
      let
        # Extract the browser app path from the buildCommand
        # It appears in patterns like: cp "/nix/store/...-firefox-unwrapped-.../Applications/Firefox.app/$file"
        matches = builtins.match ''.*cp "(/nix/store/[^"]+/Applications/Firefox\.app)/\$file" "\$file".*'' oldAttrs.buildCommand;
        browserAppPath =
          if matches != null then builtins.head matches
          else throw "firefox-audio-fix overlay: could not extract browser path from buildCommand";

        # The old pattern with the actual store path substituted
        oldPattern = ''
# The omni.ja files have to be copied and not symlinked, otherwise tabs crash.
# Maybe related to how omni.ja file is mmapped into memory. See:
# https://github.com/mozilla/gecko-dev/blob/b1662b447f306e6554647914090d4b73ac8e1664/modules/libjar/nsZipArchive.cpp#L204
#
# The *.dylib files are copied, otherwise some basic functionality, e.g. Crypto API, is broken.
for file in $(find . -name "omni.ja" -o -name "*.dylib"); do
  rm "''$file"
  cp "${browserAppPath}/''$file" "''$file"
done'';

        # The new pattern that detects all Mach-O shared libraries
        newPattern = ''
# The omni.ja files have to be copied and not symlinked, otherwise tabs crash.
# Maybe related to how omni.ja file is mmapped into memory. See:
# https://github.com/mozilla/gecko-dev/blob/b1662b447f306e6554647914090d4b73ac8e1664/modules/libjar/nsZipArchive.cpp#L204
for file in $(find . -name "omni.ja"); do
  rm "''$file"
  cp "${browserAppPath}/''$file" "''$file"
done

# Mach-O shared libraries must be copied, not symlinked, otherwise some
# functionality like Crypto API and audio/video codecs is broken.
# This catches both *.dylib and extensionless shared libraries like XUL.
while IFS= read -r -d "" file; do
  if file -bL "''$file" | grep -q "Mach-O.*dynamically linked shared library"; then
    rm "''$file"
    cp "${browserAppPath}/''$file" "''$file"
  fi
done < <(find . -type l -print0)'';

        patched = builtins.replaceStrings [ oldPattern ] [ newPattern ] oldAttrs.buildCommand;
      in
      assert patched != oldAttrs.buildCommand
        || throw "firefox-audio-fix overlay: pattern not found in buildCommand. The upstream wrapper.nix may have changed.";
      patched;
  });

in
prev.lib.optionalAttrs prev.stdenv.isDarwin {
  firefox = patchFirefoxWrapper prev.firefox;
  firefox-bin = patchFirefoxWrapper prev.firefox-bin;
  firefox-devedition = patchFirefoxWrapper prev.firefox-devedition;
  firefox-devedition-bin = patchFirefoxWrapper prev.firefox-devedition-bin;
  firefox-esr = patchFirefoxWrapper prev.firefox-esr;
  firefox-esr-bin = patchFirefoxWrapper prev.firefox-esr-bin;
}
