{ config, lib, pkgs, ... }:
{
  systemd.services.cka = {
    enable = true;
    path = [ pkgs.git ];
    serviceConfig = {
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.nix}/bin/nix develop -c npm run host'";
      WorkingDirectory = " /home/dmytro/cka ";
    };
    wantedBy = [
      "multi-user.target"
    ];
  };
  networking.firewall.allowedTCPPorts = [ 5173 ];
}

