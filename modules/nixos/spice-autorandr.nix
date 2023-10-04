{ config, lib, pkgs, ... }:
let cfg = config.services.spice-autorandr;
in {
  options.services.spice-autorandr = {
    enable = lib.mkEnableOption (lib.mdDoc "Enable spice-autorandr service that will automatically resize display to match SPICE client window size.");
    package = lib.mkPackageOptionMD pkgs "spice-autorandr" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ spice-autorandr ];
    systemd.user.services.spice-autorandr = {
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/spice-autorandr";
        Restart = "on-failure";
      };
      wantedBy = [ "default.target" ];
      after = [ "spice-vdagentd.service" ];
    };
  };
}
