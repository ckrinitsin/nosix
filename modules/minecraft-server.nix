{ config, libs, pkgs, ... }:
let
  unstable = import <nixos-unstable> {};
in
{

  services.minecraft-server = {
    package = unstable.papermc;
    enable = true;
    eula = true;
    openFirewall = true;

    declarative = true;
    whitelist = {
      Elenal = "65bad3ad-e8af-43b2-8d77-5cd6bcc56c43";
      Karuzo03 = "88ec7147-1bf5-455d-b6b5-c5771796caef";
    };
    serverProperties = {
      max-players = 2;
      motd = "<3";
      white-list = true;
    };

    dataDir = "/var/lib/minecraft";
  };

}
