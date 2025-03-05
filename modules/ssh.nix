{ config, libs, pkgs, ... }:
{

  environment.systemPackages = [ pkgs.openssh ];

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };
  networking.firewall.allowedTCPPorts = [ 22 ];

}
