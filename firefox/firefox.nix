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

  # Matches programs.firefox.configPath below.
  configPath = ".mozilla/firefox";

  # The profile directories under configPath; used by the extension-restart hook.
  profilePaths = map (p: "${configPath}/Profiles/${p}") [ "work" "personal" ];

  # Both profiles belong to one profile group, which is what Firefox's profile switcher
  # lists.  This reproduces the layout Firefox creates itself: profiles.ini holds a single
  # entry for the group, tagged with its StoreID; the group's database, Profile
  # Groups/<StoreID>.sqlite, lists the member profiles; and each member finds the group
  # through its toolkit.profiles.storeID pref.
  #
  # home-manager can't express this yet, so the profiles.ini and database handling below
  # works around it; drop it once upstream supports the new profile system:
  # https://github.com/nix-community/home-manager/issues/6934
  profileGroupID = "196ad5d1";

  sharedSettings = {
    "extensions.autoDisableScopes" = 0;
    "browser.profiles.enabled" = true;
    "browser.profiles.created" = true;
    "toolkit.profiles.storeID" = profileGroupID;
  };

  # Both profiles share one extension set for now; give a profile its own list (e.g.
  # sharedExtensions ++ [ ... ]) to diverge.
  sharedExtensions = [
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

  sharedSearch = {
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


  # The nixpkgs wrapper makes Contents/MacOS/firefox a script that sets some environment
  # variables and execs the real binary.  On macOS 27, whenever CFBundleExecutable
  # execs into another binary (script or compiled wrapper alike), LaunchServices never
  # ties the running app back to its pid: NSRunningApplication reports pid -1, so
  # nothing can reach Firefox's windows through the Accessibility API, and Rectangle
  # cannot move or resize them.
  #
  # So put the real binary back at CFBundleExecutable, and have LaunchServices set the
  # wrapper's --set variables (MOZ_APP_DATA among them) through Info.plist's
  # LSEnvironment instead.  overrideAttrs survives home-manager's .override call, as
  # the wrapper is built with lib.makeOverridable.
  firefox = if !pkgs.stdenv.isDarwin then pkgs.firefox else pkgs.firefox.overrideAttrs (old: {
    buildCommand = old.buildCommand + ''
      mv "$oldExe" "$executablePath"

      env=""
      set -- "''${makeWrapperArgs[@]}"
      while (( $# )); do
        if [[ $1 == --set ]]; then env+="<key>$2</key><string>$3</string>"; shift 3; else shift; fi
      done
      plist="$out/Applications/Firefox.app/Contents/Info.plist"
      sed '/<key>LSEnvironment<\/key>/{n; s|<dict>|<dict>'"$env"'|}' "$(readlink -f "$plist")" > plist.tmp
      grep -q MOZ_SYSTEM_DIR plist.tmp
      mv -f plist.tmp "$plist"
    '';
  });
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
    package = firefox;
    # macOS 27 denies Firefox builds not signed by Mozilla write access to
    # ~/Library/Application Support/Firefox (TCC app-data protection), which surfaces
    # as the misleading "A copy of Firefox is already open" dialog.  A non-default
    # configPath makes home-manager pass it to the nixpkgs wrapper as appDataDir
    # (MOZ_APP_DATA), moving Firefox's data, and the profile, out of the guarded
    # directory.
    inherit configPath;
    profiles = {
      work = {
        id = 0;
        isDefault = true;
        settings = sharedSettings;
        extensions.packages = sharedExtensions;
        search = sharedSearch;
      };
      personal = {
        id = 1;
        settings = sharedSettings;
        extensions.packages = sharedExtensions;
        search = sharedSearch;
      };
    };
  };

  # home-manager links a read-only profiles.ini listing every profile.  Firefox rewrites
  # profiles.ini on every start and profile switch (repointing the group's Path at the
  # profile last used), and a member listed there too would be taken for a group of its
  # own.  So drop home-manager's link and install a writable copy listing only the group,
  # reset on every switch.
  home.file."${configPath}/profiles.ini".enable = lib.mkForce false;

  # Also register both profiles in the group's database.  INSERT OR IGNORE leaves rows
  # alone once they exist, so names and avatars changed in Firefox stick.
  #
  # After linkGeneration, which removes the profiles.ini link left by earlier generations.
  home.activation.firefoxProfileGroup = lib.hm.dag.entryAfter ["linkGeneration"] ''
    ini="$HOME/${configPath}/profiles.ini"
    rm -f "$ini"
    install -m 644 ${pkgs.writeText "profiles.ini" (lib.generators.toINI { } {
      General.StartWithLastProfile = 1;
      Profile0 = {
        Name = "work";
        Path = "Profiles/work";
        IsRelative = 1;
        Default = 1;
        StoreID = profileGroupID;
      };
    })} "$ini"

    db="$HOME/${configPath}/Profile Groups/${profileGroupID}.sqlite"
    mkdir -p "$(dirname "$db")"
    ${pkgs.sqlite}/bin/sqlite3 -cmd '.timeout 5000' "$db" <<'EOF'
    CREATE TABLE IF NOT EXISTS "Profiles" (
      id      INTEGER NOT NULL,
      path    TEXT NOT NULL UNIQUE,
      name    TEXT NOT NULL,
      avatar  TEXT NOT NULL,
      themeId TEXT NOT NULL,
      themeFg TEXT NOT NULL,
      themeBg TEXT NOT NULL,
      PRIMARY KEY(id)
    );
    INSERT OR IGNORE INTO Profiles (path, name, avatar, themeId, themeFg, themeBg) VALUES
      ('Profiles/work', 'Work', 'briefcase', 'default-theme@mozilla.org', 'rgb(21,20,26)', 'rgb(240,240,244)'),
      ('Profiles/personal', 'Personal', 'heart', 'default-theme@mozilla.org', 'rgb(21,20,26)', 'rgb(240,240,244)');
    EOF
  '';

  home.activation.restartFirefoxIfExtensionsChanged = lib.hm.dag.entryAfter ["writeBoundary"] ''
    stateFile="$HOME/.local/state/hm-firefox-extensions-hash"
    mkdir -p "$(dirname "$stateFile")"

    currentHash=$(for p in ${lib.escapeShellArgs profilePaths}; do
        ls "$HOME/$p/extensions"/*.xpi 2>/dev/null
      done | xargs realpath 2>/dev/null | sort | ${pkgs.coreutils}/bin/sha256sum || echo "none")
    savedHash=$(cat "$stateFile" 2>/dev/null || echo "")

    if [ "$currentHash" != "$savedHash" ]; then
      printf '%s' "$currentHash" > "$stateFile"
      if pgrep -q firefox >/dev/null 2>&1; then
        echo "Firefox extensions changed — restarting Firefox..."
        personalRunning=$(pgrep -qf -- 'Profiles/personal' && echo 1 || true)
        # Each profile runs as its own instance of the same bundle, and an Apple event
        # only reaches one of them, so keep asking until all have quit.
        while pgrep -q firefox >/dev/null 2>&1; do
          osascript -e 'tell application "Firefox" to quit' >/dev/null 2>&1 || true
          sleep 0.5
        done
        open -a Firefox
        if [ -n "$personalRunning" ]; then
          open -n -a Firefox --args --profile "$HOME/${configPath}/Profiles/personal"
        fi
      fi
    fi
  '';
}
