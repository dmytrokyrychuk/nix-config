{ config, lib, pkgs, ... }:
{
  services.compton = {
    enable = true;
    settings = {
      inactive-dim = 0.05;
    };
  };

  services.xserver = {
    enable = true;
    desktopManager.xterm.enable = false;
    displayManager.defaultSession = "none+i3";
    windowManager.i3.enable = true;
  };
}
