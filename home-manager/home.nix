# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    outputs.homeManagerModules.i3
    outputs.homeManagerModules.kitty

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.modifications
      outputs.overlays.additions
      outputs.overlays.unstable-packages
      outputs.overlays.bump-kitty-themes

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
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "dmytro";
    homeDirectory = "/home/dmytro";
  };

  # Add stuff for your user as you see fit:
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };
  # home.packages = with pkgs; [ steam ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;
  programs.git.userName = "Dmytro Kyrychuk";
  programs.git.userEmail = "dmytro@kyrych.uk";

  programs.qutebrowser.enable = true;

  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    package = pkgs.vscode;
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      jnoortheen.nix-ide
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "vscode-icons";
        publisher = "vscode-icons-team";
        version = "12.2.0";
        sha256 = "sha256-PxM+20mkj7DpcdFuExUFN5wldfs7Qmas3CnZpEFeRYs=";
      }
    ];
    userSettings = {
      nix.enableLanguageServer = true;
      nix.serverPath = "nil";
      nix.serverSettings.nil.formatting.command = [ "nixpkgs-fmt" ];

      workbench = {
        iconTheme = "vscode-icons";
      };

      editor.lineNumbers = "relative";
    };
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.bash.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
