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
    profiles.frank.settings = {
      "extensions.autoDisableScopes" = 0;
    };
    profiles.frank.extensions.packages = [
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
          mozPermissions = [
            "tabs"
            "bookmarks"
            "history"
            "storage"
            "sessions"
            "notifications"
            "scripting"
            "webNavigation"
            "clipboardRead"
            "clipboardWrite"
            "<all_urls>"
            "file:///"
            "file:///*/"
          ];
          platforms = platforms.all;
        };
      })
      (buildFirefoxXpiAddon rec {
        pname = "ublock_origin";
        version = "1.63.2";
        addonId = "uBlock0@raymondhill.net";
        url = "https://addons.mozilla.org/firefox/downloads/file/4458450/${pname}-${version}.xpi";
        sha256 = "sha256-2TF2zvTcBC5BulAKoqkOXVe1vndEnL1SIRFYXjoM0Vg=";
        meta = with lib; {
          description = "Free, open-source ad content blocker.";
          license = licenses.gpl3;
          platforms = platforms.all;
          mozPermissions = [
            "alarms"
            "dns"
            "menus"
            "privacy"
            "storage"
            "tabs"
            "unlimitedStorage"
            "webNavigation"
            "webRequest"
            "webRequestBlocking"
            "<all_urls>"
            "http://*/*"
            "https://*/*"
          ];
        };
      })
      (buildFirefoxXpiAddon rec {
        pname = "browserpass_ce";
        version = "3.9.0";
        addonId = "browserpass@maximbaz.com";
        url = "https://addons.mozilla.org/firefox/downloads/file/4406417/${pname}-${version}.xpi";
        sha256 = "sha256-UUwaYG17yCBF0hvLxuWx5QB0RqsyqgHw8X++C94D7ww=";
        meta = with lib; {
          homepage = "https://github.com/browserpass/browserpass-extension";
          description = "Browserpass web extension ";
          license = licenses.isc;
          mozPermissions = [
            "activeTab"
            "alarms"
            "tabs"
            "clipboardRead"
            "clipboardWrite"
            "nativeMessaging"
            "notifications"
            "webRequest"
            "webRequestBlocking"
            "http://*/*"
            "https://*/*"
          ];
          platforms = platforms.all;
        };
      })
      (buildFirefoxXpiAddon rec {
        pname = "consent_o_matic";
        version = "1.1.5";
        addonId = "gdpr@cavi.au.dk";
        url = "https://addons.mozilla.org/firefox/downloads/file/4515369/${pname}-${version}.xpi";
        sha256 = "sha256-ohGavDKWONbnrxq05VSKNIRl4C7sEd4I3uCvhJGZI9w=";
        meta = with lib; {
          homepage = "https://consentomatic.au.dk/";
          description = "Automatic handling of GDPR consent forms";
          license = licenses.mit;
          mozPermissions = [ "activeTab" "tabs" "storage" "<all_urls>" ];
          platforms = platforms.all;
        };
      })
    ];
    profiles.frank.search = {
      force = true;
      engines = {
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
        "doc.rust-lang.org" = {
          urls = [{
            template = "https://doc.rust-lang.org/std/index.html";
            params = [
              { name = "search"; value = "{searchTerms}"; }
            ];
          }];
          definedAliases = [ "@rs" ];
        };
        "crates.io" = {
          urls = [{
            template = "https://crates.io/search";
            params = [
              { name = "q"; value = "{searchTerms}"; }
            ];
          }];
          definedAliases = [ "@crates" ];
        };
      };
    };
  };
}
