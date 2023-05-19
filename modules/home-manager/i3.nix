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
          "${mod}+shift+${left}" = "focus left";
          "${mod}+shift+${right}" = "focus right";
          "${mod}+shift+${up}" = "focus up";
          "${mod}+shift+${down}" = "focus down";
        };
    };
  };
}
