{ pkgs, libs, config, ... }:
{

  services.syncthing = {
    enable = true;
    guiAddress = "localhost:8384";
    dataDir = "/var/lib/syncthing";
    openDefaultPorts = true;
  };
  
  networking.firewall.allowedTCPPorts = [ 8384 ];
}
