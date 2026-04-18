{ config, lib, pkgs, ... }:
let
  cfg = config.services.kanata;

  # Stable binary path; used in ProgramArguments so the Input Monitoring TCC
  # grant survives darwin-rebuild without re-approval.
  stableBin = "/usr/local/bin/kanata";

  # The Karabiner-DriverKit-VirtualHIDDevice manager app must live inside
  # /Applications as a real directory — macOS rejects symlinked DriverKit
  # extensions. We use a .Nix-Kanata prefix to avoid colliding with any
  # existing Karabiner-Elements install.
  vhidDir = "/Applications/.Nix-Kanata";
  vhidManager = "${vhidDir}/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager";
  vhidDaemon = "${vhidDir}/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon";

  mkConfig = name: keyboard:
    pkgs.writeTextFile {
      name = "kanata-${name}.kbd";
      text = keyboard.config;
    };

  mkDaemon = name: keyboard:
    lib.nameValuePair "kanata-${name}" {
      serviceConfig = {
        Label = "org.nixos.kanata.${name}";
        ProgramArguments = [
          stableBin
          "--cfg"
          "${if keyboard.configFile != null
             then toString keyboard.configFile
             else mkConfig name keyboard}"
        ] ++ keyboard.extraArgs;
        RunAtLoad = true;
        KeepAlive = true;
        StandardOutPath = "/var/log/kanata-${name}.out";
        StandardErrorPath = "/var/log/kanata-${name}.err";
      };
    };
in
{
  options.services.kanata = {
    enable = lib.mkEnableOption "kanata, an advanced keyboard remapper";

    package = lib.mkPackageOption pkgs "kanata" {
      example = [ "kanata-with-cmd" ];
    };

    keyboards = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          config = lib.mkOption {
            type = lib.types.lines;
            default = "";
            description = "Kanata config file content.";
          };
          configFile = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            default = null;
            description = "Path to an existing kanata config file. Overrides config.";
          };
          extraArgs = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
            description = "Extra command line arguments to pass to kanata.";
          };
        };
      });
      default = {};
      description = "Keyboard configurations to manage, one launchd daemon per entry.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    system.activationScripts.preActivation.text = lib.mkBefore ''
      # Install the Karabiner VirtualHIDDevice manager app (must be a real
      # copy inside /Applications — symlinks are rejected by macOS for DriverKit).
      rm -rf ${vhidDir}
      mkdir -p ${vhidDir}
      cp -r ${pkgs.karabiner-elements.driver}/Applications/.Karabiner-VirtualHIDDevice-Manager.app ${vhidDir}
      cp -r "${pkgs.karabiner-elements.driver}/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app" ${vhidDir}
    '';

    system.activationScripts.postActivation.text = lib.mkAfter ''
      # Keep a stable kanata binary path so the Input Monitoring TCC grant
      # survives Nix store hash changes across rebuilds.
      mkdir -p /usr/local/bin
      ln -sf ${lib.getExe cfg.package} ${stableBin}
    '';

    # Activate the DriverKit system extension at login. Harmless if already
    # active; needed if the extension is ever deactivated (e.g. after a macOS
    # update). Approval in System Settings → General → Login Items &
    # Extensions → Driver Extensions is required once on first install.
    launchd.user.agents.kanata-vhid-activate = {
      serviceConfig = {
        Label = "org.nixos.kanata.vhid-activate";
        ProgramArguments = [ vhidManager "activate" ];
        RunAtLoad = true;
      };
    };

    # Must run as root: the VirtualHIDDevice IPC socket lives under
    # /Library/Application Support/org.pqrs/tmp/rootonly/ (root-only).
    # The VirtualHIDDevice daemon opens the IPC socket that kanata connects to
    # for emitting remapped key events. It was previously managed by the
    # karabiner-elements nix-darwin module as Karabiner-DriverKit-VirtualHIDDeviceClient;
    # the binary was renamed to Karabiner-VirtualHIDDevice-Daemon in 15.7.0.
    launchd.daemons = lib.mapAttrs' mkDaemon cfg.keyboards // {
      karabiner-vhid-daemon = {
        serviceConfig = {
          Label = "org.pqrs.Karabiner-VirtualHIDDevice-Daemon";
          ProgramArguments = [ vhidDaemon ];
          ProcessType = "Interactive";
          KeepAlive = true;
          StandardOutPath = "/var/log/karabiner-vhid-daemon.out";
          StandardErrorPath = "/var/log/karabiner-vhid-daemon.err";
        };
      };
    };
  };
}

# vi:sw=2:ts=2:et
