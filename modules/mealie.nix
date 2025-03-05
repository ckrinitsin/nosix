{ config, libs, pkgs, ... }:
let
  unstable = import <nixos-unstable> {};
in
{

  services.mealie = {
    enable = true;
    package = unstable.mealie;
  };

  networking.firewall.allowedTCPPorts = [ 9000 8080 ];

}
