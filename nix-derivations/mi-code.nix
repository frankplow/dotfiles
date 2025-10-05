{ stdenv
, fetchurl
, nodejs
, cacert
, jq
, makeWrapper
, lib
}:
  stdenv.mkDerivation rec {
    pname = "mi-code";
    version = "0.0.21";

    src = fetchurl {
      url = "https://pkgs.d.xiaomi.net:443/artifactory/api/npm/mi-npm/@mi/mi-code-cli/-/@mi/mi-code-cli-${version}.tgz";
      hash = "sha256-8qCI4M5G7w0cRm1TogU7FpIBvj9GpYauEQJGcM7iQjc=";
    };

    nativeBuildInputs = [ nodejs cacert jq makeWrapper ];

    postUnpack = ''
      # Remove lifecycle scripts from package.json
      cd $sourceRoot
      jq 'del(.scripts.generate, .scripts.bundle, .scripts.prepare)' package.json > package.json.tmp
      mv package.json.tmp package.json
      cd -
    '';

    buildPhase = ''
      export HOME=$TMPDIR
      export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
      export NIX_SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt

      npm install --global --prefix=$TMPDIR/npm-global --registry=https://pkgs.d.xiaomi.net/artifactory/api/npm/mi-npm/
    '';

    installPhase = ''
      mkdir -p $out/lib/node_modules/${pname}

      # Copy files, following symlinks with -L
      cp -rL . $out/lib/node_modules/${pname}/ 2>/dev/null || {
        # If -L fails (circular symlinks), copy without following and fix later
        cp -r . $out/lib/node_modules/${pname}/
        # Remove broken symlinks
        find $out/lib/node_modules/${pname} -xtype l -delete
      }

      # Create bin directory
      mkdir -p $out/bin

      cd $out/lib/node_modules/${pname}

      # Extract and create bin entries
      BIN_ENTRIES=$(jq -r '.bin // {} | to_entries[] | "\(.key):\(.value)"' package.json 2>/dev/null || true)

      if [ -n "$BIN_ENTRIES" ]; then
        echo "$BIN_ENTRIES" | while IFS=: read -r name path; do
          path=''${path#./}
          if [ -f "$out/lib/node_modules/${pname}/$path" ]; then
            makeWrapper ${nodejs}/bin/node $out/bin/$name \
              --add-flags "$out/lib/node_modules/${pname}/$path"
          fi
        done
      fi
    '';
  }
