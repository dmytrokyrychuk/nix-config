# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.

{
  i3 = import ./i3.nix;
  kitty = import ./kitty.nix;
  rofi = import ./rofi.nix;
  fonts = import ./fonts.nix;
  firefox = import ./firefox.nix;
}
