# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

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

  # FIXME: Add the rest of your current configuration

  environment.systemPackages = [
    pkgs.spice-vdagent
  ];

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



  # TODO: This is just an example, be sure to use whatever bootloader you prefer
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    # FIXME: Replace with your username
    dmytro = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      initialPassword = "correcthorsebatterystaple";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
	"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILFn/AElBrb+DOO3Mf075fGIfBuhd4UBIs91mJrZP11o"
	"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBGyeBflbdU9G2eDbXLwl2TPAc4nMdg9icnXJZzY5po9"
	"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPPrQqC7y213sUAFfYsEK46aQ9hOGREkbG7NSJryP/Wg"
	"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDUZc2SIBWOfg2vpnIxizPATv9NvhQhYrb/NH5XB8ObtfVERXPDHWxjZlRDD9QhqBdLOpOZflV2ql++jOuoILrOoFo/5KN6USyt8WKPBsqm04cbB3cnN/LqCbzjF8hhnAGwxCc9fSJqYYVwqe4iGdKRHQoRGrBtwLKl8fuDhxkB72dVCpD8MEz7eE+X7dhWcktnEO+MA3qVova+SLOH68SbufaBqgtYarhXc+zkiFK3vaRdTOUnKvatFZj1vATy29h+MmDlFJEA+4ZUkXTJw7nVDyuJsWLf1N5csQqm/ijVOTtt1w0ygGYG8vC5IN48fboqYgU+a5yO9ZyfoHYl8LOj1chdIwzuyQMAtV5PGzvaIsaxHhaQ1EdtpaOlFNRsDHFvp9DZ17QA+JObhefO21Nxw6ls4JkgQ3DbpByOypNav238kNTIdQ0Oo2tWD9v1eKrIAyb/oMqlOf25hos/jUG/7mfPqWNeBm59BBoXQd9eT+WGQj7g4Zbgjd0q2jRz/Iaxu4h+Hp9lbzf3hKe4pHLRtKc/mH1cIFehmXl7ShVFJpMG8N9J8oE4Fakn91zbZdE9fA4ncbdSPLALBXc5vP3TqagE9p1hEBykW4r4cAP6mrjh0xLBTMEYV1ewIjD8qC6XR7i8pXL22xMtFr9XkgPU0RlAHp/rrvh6oOrh37o6qw=="
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
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

  services.xserver = {
    enable = true;
    desktopManager.xfce.enable = true;
  };

  networking.hostName = "dkc01";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}
