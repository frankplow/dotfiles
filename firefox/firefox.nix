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

  # macOS 27 tightened TCC's app-data protection (kTCCServiceSystemPolicyAppDataDetailed).
  # ~/Library/Application Support/Firefox is guarded, and because the nixpkgs wrapper
  # replaces Contents/MacOS/firefox with an unsigned bash script, TCC refuses to even
  # prompt for an "unentitled binary" and denies outright:
  #
  #   System Policy: deny(1) file-write-create .../Profiles/frank/.parentlock
  #
  # Firefox then cannot take the profile lock, which surfaces as the thoroughly
  # misleading "A copy of Firefox is already open. Only one copy of Firefox can be open
  # at a time." with no Firefox running.  Patching CFBundleIdentifier and ad-hoc signing
  # both fail; TCC wants a real Developer ID matching the directory's owner record.
  #
  # Keeping the profile outside the guarded directory sidesteps the denial completely.
  # Firefox's macOS profile root is not settable by environment variable (its
  # MOZ_LEGACY_PROFILES is Linux-only), so the profile must be selected with --profile
  # at launch, which means shipping an app bundle whose entry point adds the flag.
  # Everything but that entry point is mirrored as symlinks to avoid duplicating the
  # ~500MB bundle in the store.
  firefoxProfilePath = ".mozilla/firefox/Profiles/frank";

  # Threaded through .override because home-manager's wrapPackage calls
  # package.override to inject its own cfg/extraPolicies/pkcs11Modules; without
  # re-applying the patch there the override hands back an unwrapped launcher.
  withRelocatedProfile = firefox:
    pkgs.runCommand "${firefox.name}-relocated-profile"
    {
      inherit (firefox) meta;
      passthru = (firefox.passthru or { }) // {
        override = args: withRelocatedProfile (firefox.override args);
      };
    }
    ''
      mkdir -p "$out"
      cp -as ${firefox}/. "$out"
      # cp -a preserves the store's read-only directory modes; reopen the directories
      # (only the directories, so symlink targets are left alone) for writing.
      find "$out" -type d -exec chmod u+w {} +

      for launcher in "$out/Applications/Firefox.app/Contents/MacOS/firefox" "$out/bin/firefox"; do
        [ -e "$launcher" ] || continue
        rm "$launcher"
        {
          echo '#!${pkgs.runtimeShell}'
          echo 'exec "${firefox}/Applications/Firefox.app/Contents/MacOS/firefox" --profile "$HOME/${firefoxProfilePath}" "$@"'
        } > "$launcher"
        chmod +x "$launcher"
      done
    '';
in
  {
  # Declaratively manages the native messaging host manifest under
  # ~/Library/Application Support/Mozilla/NativeMessagingHosts so it always
  # points at the current browserpass store path. Without this, the manifest
  # has to be created by hand and goes stale (pointing at a since-GC'd store
  # path) the next time browserpass is rebuilt, causing the extension to hang
  # forever on "Loading available logins...".
  programs.browserpass = {
    enable = true;
    browsers = [ "firefox" ];
  };

  programs.firefox = {
    enable = true;
    package = withRelocatedProfile pkgs.firefox;
    # Moves home-manager's own profile writes (user.js, extensions, search.json.mozlz4)
    # alongside the relocated profile.  Internal option, but it is the only seam for
    # this; profilesPath defaults to "${configPath}/Profiles" on Darwin.
    configPath = ".mozilla/firefox";
    profiles.frank.settings = {
      "extensions.autoDisableScopes" = 0;
      # Disable Firefox 128+ multi-profile UI (removes the star/avatar toolbar icon).
      "browser.profiles.enabled" = false;
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
      (buildFirefoxXpiAddon rec {
        pname = "bitwarden";
        version = "2026.6.1";
        addonId = "{446900e4-71c2-419f-a6a7-df9c091e268b}";
        url = "https://addons.mozilla.org/firefox/downloads/file/4875950/bitwarden_password_manager-2026.6.1.xpi";
        sha256 = "7ba16c3d422ab287db17b014a4683bace36341e471e4d4fd58ac2b616c6ac17d";
        meta = with lib; {
          homepage = "https://bitwarden.com";
          description = "At home, at work, or on the go, Bitwarden easily secures all your passwords, passkeys, and sensitive information.";
          license = licenses.gpl3;
          mozPermissions = [
            "<all_urls>"
            "*://*/*"
            "alarms"
            "clipboardRead"
            "clipboardWrite"
            "contextMenus"
            "idle"
            "nativeMessaging"
            "storage"
            "tabs"
            "unlimitedStorage"
            "webNavigation"
            "webRequest"
            "webRequestBlocking"
            "notifications"
            "file:///*"
          ];
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

  home.activation.restartFirefoxIfExtensionsChanged = lib.hm.dag.entryAfter ["writeBoundary"] ''
    extensionsDir="$HOME/${firefoxProfilePath}/extensions"
    stateFile="$HOME/.local/state/hm-firefox-extensions-hash"
    mkdir -p "$(dirname "$stateFile")"

    currentHash=$(ls "$extensionsDir"/*.xpi 2>/dev/null \
      | xargs realpath 2>/dev/null | sort | ${pkgs.coreutils}/bin/sha256sum || echo "none")
    savedHash=$(cat "$stateFile" 2>/dev/null || echo "")

    if [ "$currentHash" != "$savedHash" ]; then
      printf '%s' "$currentHash" > "$stateFile"
      if pgrep -q firefox >/dev/null 2>&1; then
        echo "Firefox extensions changed — restarting Firefox..."
        osascript -e 'tell application "Firefox" to quit'
        while pgrep -q firefox >/dev/null 2>&1; do sleep 0.5; done
        open -a Firefox
      fi
    fi
  '';
}
