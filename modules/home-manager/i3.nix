{ config, lib, pkgs, ... }:
{
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      keybindings =
        let
          mod = "Mod1";
          up = "i";
          down = "k";
          left = "j";
          right = "l";
        in
        lib.mkOptionDefault {
          # Focus
          "${mod}+${left}" = "focus left";
          "${mod}+${right}" = "focus right";
          "${mod}+${up}" = "focus up";
          "${mod}+${down}" = "focus down";

          # Move
          "${mod}+Shift+${left}" = "move left";
          "${mod}+Shift+${right}" = "move right";
          "${mod}+Shift+${up}" = "move up";
          "${mod}+Shift+${down}" = "move down";
        };
    };
  };
}
