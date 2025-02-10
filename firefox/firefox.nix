{ pkgs, pkgs-unstable, lib, fetchurl, ... }:
let
  # https://github.com/nix-community/nur-combined/blob/master/repos/rycee/pkgs/firefox-addons/default.nix#L5-L25
  buildFirefoxXpiAddon = { pname, version, addonId, url, sha256, meta, ... }:
    pkgs.stdenv.mkDerivation {
      name = "${pname}-${version}";

      inherit meta;

      src = pkgs.fetchurl { inherit url sha256; };

      preferLocalBuild = true;
      allowSubstitutes = true;

      passthru = { inherit addonId; };

      buildCommand = ''
        dst="$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
        mkdir -p "$dst"
        install -v -m644 "$src" "$dst/${addonId}.xpi"
      '';
    };
in
  {
  programs.firefox = {
    enable = true;
    package = pkgs-unstable.firefox-unwrapped;
    profiles.frank.extensions = [
      (buildFirefoxXpiAddon rec {
        pname = "vimium-ff";
        version = "2.1.2";
        addonId = "{d7742d87-e61d-4b78-b8a1-b469842139fa}";
        url = "https://addons.mozilla.org/firefox/downloads/file/4259790/${pname}-${version}.xpi";
        sha256 = "sha256-O51D7id/83TjsRU/l9wgywbmVBFqgzZ0x5tDuIh4IOE=";
        meta = with lib; {
          homepage = "https://github.com/philc/vimium";
          description = " The hacker's browser.";
          license = licenses.mit;
          platforms = platforms.all;
        };
      })
      (buildFirefoxXpiAddon rec {
        pname = "ublock_origin";
        version = "1.54.0";
        addonId = "";
        url = "https://addons.mozilla.org/firefox/downloads/file/4198829/${pname}-${version}.xpi";
        sha256 = "sha256-l5cWCQgZFxD/CFhTa6bcKeytmSPDCyrW0+XjcddZ5E0=";
        meta = with lib; {
          homepage = "https://ublockorigin.com/";
          description = "Free, open-source ad content blocker.";
          license = licenses.gpl3;
          platforms = platforms.all;
        };
      })
      (buildFirefoxXpiAddon rec {
        pname = "browserpass_ce";
        version = "3.9.0";
        addonId = "af7b04d9-914d-4aa8-b62f-67b40bcf02c7";
        url = "https://addons.mozilla.org/firefox/downloads/file/4406417/${pname}-${version}.xpi";
        sha256 = "sha256-UUwaYG17yCBF0hvLxuWx5QB0RqsyqgHw8X++C94D7ww=";
        meta = with lib; {
          homepage = "https://github.com/browserpass/browserpass-extension";
          description = "Browserpass web extension ";
          license = licenses.isc;
          platforms = platforms.all;
        };
      })
    ];
    profiles.frank.search.engines = {
      "Nix Packages" = {
        urls = [{
          template = "https://search.nixos.org/packages";
          params = [
            { name = "type"; value = "packages"; }
            { name = "query"; value = "{searchTerms}"; }
          ];
        }];
        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = [ "@np" ];
      };
      "Home Manager" = {
        urls = [{
          template = "https://home-manager-options.extranix.com";
          params = [
            { name = "query"; value = "{searchTerms}"; }
          ];
        }];
        icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        definedAliases = [ "@hm" ];
      };
      "cppreference.com" = {
        urls = [{
          template = "https://www.google.com/search";
          params = [
            { name = "q"; value = "site%3Acppreference.com+{searchTerms}"; }
          ];
        }];
        definedAliases = [ "@cpp" ];
      };
      "docs.python.org" = {
        urls = [{
          template = "https://docs.python.org/3/search.html";
          params = [
            { name = "q"; value = "{searchTerms}"; }
          ];
        }];
        definedAliases = [ "@py" ];
      };
    };
  };
}
