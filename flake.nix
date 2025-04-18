{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, nix-darwin, vscode-server, ... }:
  let
    cfg-darwin = { pkgs, pkgs-unstable, lib, ... }: {
      environment.systemPackages = [];

      environment.shells = with pkgs; [ bashInteractive zsh fish ];
      programs.zsh = rec {
        enable = true;
        # Disable system-wide completions for speed because we configure zsh using
        # home-manager.  See https://github.com/nix-community/home-manager/issues/108
        enableCompletion = false;
        enableBashCompletion = enableCompletion;
      };
      programs.fish.enable = true;
      # FIXME: This is needed to address bug where the $PATH is re-ordered by
      # the `path_helper` tool, prioritising Apple’s tools over the ones we’ve
      # installed with nix.
      #
      # This gist explains the issue in more detail: https://gist.github.com/Linerre/f11ad4a6a934dcf01ee8415c9457e7b2
      # There is also an issue open for nix-darwin: https://github.com/LnL7/nix-darwin/issues/122
      programs.fish.loginShellInit =
        let
          # We should probably use `config.environment.profiles`, as described in
          # https://github.com/LnL7/nix-darwin/issues/122#issuecomment-1659465635
          # but this takes into account the new XDG paths used when the nix
          # configuration has `use-xdg-base-directories` enabled. See:
          # https://github.com/LnL7/nix-darwin/issues/947 for more information.
          profiles = [
            "/etc/profiles/per-user/$USER" # Home manager packages
            "$HOME/.nix-profile"
            "(set -q XDG_STATE_HOME; and echo $XDG_STATE_HOME; or echo $HOME/.local/state)/nix/profile"
            "/run/current-system/sw"
            "/nix/var/nix/profiles/default"
          ];

          makeBinSearchPath =
            lib.concatMapStringsSep " " (path: "${path}/bin");
        in
        ''
          # Fix path that was re-ordered by Apple's path_helper
          fish_add_path --move --prepend --path ${makeBinSearchPath profiles}
          set fish_user_paths $fish_user_paths
        '';

      # Auto upgrade nix package and the daemon service.
      nix.enable = true;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Automatically deduplicate items in the store.
      nix.optimise.automatic = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      services.karabiner-elements.enable = true;

      # The platform the configuration will be used on.
      nixpkgs = {
        hostPlatform = "aarch64-darwin";
        config.allowUnfree = true;
        overlays = [
          (import ./nix-overlays/mi-code.nix)
          # karabiner-elements pinned to 14.13.0 pending resolution of
          # https://github.com/LnL7/nix-darwin/issues/1041
          (import ./nix-overlays/karabiner-elements.nix)
          (import ./nix-overlays/yuview.nix)
          (import ./nix-overlays/zulip.nix)
        ];
      };

      system.primaryUser = "frank";
      users.users.frank = {
        home = "/Users/frank";
        shell = pkgs.fish;
        uid = 1000;
      };

      homebrew = {
        enable = true;
        casks = [
          "spotify"
          # "textual"
        ];
      };
    };

    cfg-dastardly = { pkgs, pkgs-unstable, lib, ... }: {
      imports = [
        "${inputs.impermanence}/nixos.nix"
        ./dastardly-hardware.nix
      ];

      environment.persistence."/nix/persist" = {
        hideMounts = true;
        directories = [
          "/var/log"
          "/var/lib/nixos"
          "/var/lib/lastlog"
          "/var/lib/systemd/coredump"
          "/var/lib/systemd/timers"
        ];
        files = [
          "/etc/machine-id"
          "/etc/ssh/ssh_host_rsa_key"
          "/etc/ssh/ssh_host_rsa_key.pub"
          "/etc/ssh/ssh_host_ed25519_key"
          "/etc/ssh/ssh_host_ed25519_key.pub"
        ];
      };

      # Use the systemd-boot EFI boot loader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      # boot.loader.grub = {
        # useOSProber = true;
        # efiSupport = true;
        # device = "nodev";
      # };
      virtualisation.docker = {
        rootless = {
          enable = true;
          setSocketVariable = true;
        };
        storageDriver = "btrfs";
      };

      boot.kernelModules = [
        "sg"
      ];

      networking.hostName = "dastardly"; # Define your hostname.
      # Pick only one of the below networking options.
      # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
      # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

      # Set your time zone.
      time.timeZone = "Europe/London";

      # Configure network proxy if necessary
      # networking.proxy.default = "http://user:password@proxy:port/";
      # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

      # Select internationalisation properties.
      # i18n.defaultLocale = "en_US.UTF-8";
      # console = {
      #   font = "Lat2-Terminus16";
      #   keyMap = "us";
      #   useXkbConfig = true; # use xkb.options in tty.
      # };

      # Enable the X11 windowing system.
      # services.xserver.enable = true;

      # Configure keymap in X11
      # services.xserver.xkb.layout = "us";
      # services.xserver.xkb.options = "eurosign:e,caps:escape";

      # Enable CUPS to print documents.
      # services.printing.enable = true;

      # Enable sound.
      # hardware.pulseaudio.enable = true;
      # OR
      # services.pipewire = {
      #   enable = true;
      #   pulse.enable = true;
      # };

      # Enable touchpad support (enabled default in most desktopManager).
      # services.xserver.libinput.enable = true;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      services.xserver.videoDrivers = [ "nvidia" ];

      # CUDA binary cache
      nix.settings = {
        substituters = [
          "https://cache.nixos-cuda.org"
        ];
        trusted-public-keys = [
          "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
        ];
      };

      # Automatically deduplicate items in the store.
      nix.optimise.automatic = true;

      nixpkgs.config.allowUnfree = true;

      environment.shells = with pkgs; [ bashInteractive zsh fish ];
      programs.zsh = rec {
        enable = true;
        # Disable system-wide completions for speed because we configure zsh using
        # home-manager.  See https://github.com/nix-community/home-manager/issues/108
        enableCompletion = false;
        enableBashCompletion = enableCompletion;
      };

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.mutableUsers = false;
      users.defaultUserShell = pkgs.zsh;
      users.users.frank = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        initialHashedPassword = "$6$48pOH4dFViMVqfe/$G2AprxUueKf3HuzKmRb46w4w47qjRMMkpgwFPrP0H.jylC55v5eEdAaVk75y32A4Ne9OhssEKnxLnp14pGgY20";
      };

      # List packages installed in system profile. To search, run:
      # $ nix search wget
      # environment.systemPackages = with pkgs; [
      #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      #   wget
      # ];

      # Some programs need SUID wrappers, can be configured further or are
      # started in user sessions.
      # programs.mtr.enable = true;
      # programs.gnupg.agent = {
      #   enable = true;
      #   enableSSHSupport = true;
      # };

      # List services that you want to enable:

      # Enable the OpenSSH daemon.
      services.openssh.enable = true;

      boot.supportedFilesystems = [ "nfs" ];
      services.rpcbind.enable = true;

      # Open ports in the firewall.
      # networking.firewall.allowedTCPPorts = [ ... ];
      # networking.firewall.allowedUDPPorts = [ ... ];
      # Or disable the firewall altogether.
      networking.firewall.enable = false;

      services.vscode-server.enable = true;

      # Copy the NixOS configuration file and link it from the resulting system
      # (/run/current-system/configuration.nix). This is useful in case you
      # accidentally delete configuration.nix.
      # system.copySystemConfiguration = true;

      # This option defines the first version of NixOS you have installed on this particular machine,
      # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
      #
      # Most users should NEVER change this value after the initial install, for any reason,
      # even if you've upgraded your system to a new NixOS release.
      #
      # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
      # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
      # to actually do that.
      #
      # This value being lower than the current NixOS release does NOT mean your system is
      # out of date, out of support, or vulnerable.
      #
      # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
      # and migrated your data accordingly.
      #
      # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
      system.stateVersion = "24.05"; # Did you read the comment?
    };

  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake ~/.config/nix-darwin/flake.nix
    darwinConfigurations.nix-darwin = nix-darwin.lib.darwinSystem rec {
      specialArgs = {
        pkgs-unstable = import nixpkgs-unstable {
          system = "aarch64-darwin";
          config.allowUnfree = true;
        };
      };
      modules = [
        cfg-darwin
        home-manager.darwinModules.home-manager {
          home-manager.extraSpecialArgs = { pkgs-unstable = specialArgs.pkgs-unstable; };
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.frank = import ./home-manager.nix;
        }
      ];
    };
    darwinPackages = self.darwinConfigurations.nix-darwin.pkgs;

    nixosConfigurations.dastardly = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = {
        pkgs-unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
      };
      modules = [
        {
          config._module.args = {
            # currentSystem = system;
            # isNixOS = true;
            # isDarwin = false;
          };
        }
        cfg-dastardly
        home-manager.nixosModules.home-manager {
          home-manager.extraSpecialArgs = { pkgs-unstable = specialArgs.pkgs-unstable; };
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.frank = import ./home-manager.nix;
        }
        vscode-server.nixosModules.default
      ];
    };
  };
}

# vi:sw=2:ts=2:et
