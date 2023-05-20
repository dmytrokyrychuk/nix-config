{ config, lib, pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.xorg.xf86videoqxl
  ];

  services.xserver.videoDrivers = [ "qxl" ];

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
}
