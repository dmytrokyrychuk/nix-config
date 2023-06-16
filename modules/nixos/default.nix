# Add your reusable NixOS modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.

{
  gui-i3 = import ./gui-i3.nix;
  proxmox-vm-gui = import ./proxmox-vm-gui.nix;
  cka = import ./cka.nix;
}
