# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other NixOS modules here
  imports = [
    outputs.nixosModules.gui-i3
    outputs.nixosModules.proxmox-vm-gui

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.modifications
      outputs.overlays.additions

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  environment.systemPackages = [
    pkgs.nil
    pkgs.nixpkgs-fmt
  ];

  fonts.fonts = [
    pkgs.nerdfonts
  ];

  environment.variables.EDITOR = "nvim";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "uk_UA.utf8";
    LC_IDENTIFICATION = "uk_UA.utf8";
    LC_MEASUREMENT = "uk_UA.utf8";
    LC_MONETARY = "uk_UA.utf8";
    LC_NAME = "uk_UA.utf8";
    LC_NUMERIC = "uk_UA.utf8";
    LC_PAPER = "uk_UA.utf8";
    LC_TELEPHONE = "uk_UA.utf8";
    LC_TIME = "uk_UA.utf8";
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  users.users = {
    dmytro = {
      initialPassword = "correcthorsebatterystaple";
      isNormalUser = true;
      openssh.authorizedKeys.keys =
        let
          authorizedKeys = pkgs.fetchurl {
            url = "https://github.com/dmytrokyrychuk.keys";
            sha256 = "sha256-MW76pxSnJNL81lp7XJlKgwJK6jiWbTVbUEZazD0SkmM=";
          };
        in
        pkgs.lib.splitString "\n" (builtins.readFile authorizedKeys);
      extraGroups = [ "networkmanager" "wheel" ];
    };
  };

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    # Forbid root login through SSH.
    permitRootLogin = "no";
    # Use keys only. Remove if you want to SSH using password (not recommended)
    passwordAuthentication = false;
  };
  # Agent might not start at boot at first. Run the following command once, then
  # the agent will start correctly on subsequent boots:
  #   systemctl --user start ssh-agent.service
  programs.ssh.startAgent = true;

  programs.fish.enable = true;
  users.users.dmytro.shell = pkgs.fish;

  networking.hostName = "dkc01";
  networking.networkmanager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}
