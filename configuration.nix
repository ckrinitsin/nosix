{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./modules/ssh.nix
      ./modules/user.nix
      ./modules/minecraft-server.nix
      ./modules/webserver.nix
      ./modules/syncthing.nix
      ./modules/mailserver.nix
      ./modules/mealie.nix
    ];

  networking.hostName = "nixos";
  time.timeZone = "Europe/Berlin";
  networking.firewall.enable = true;

  environment.systemPackages = with pkgs; [
    git
    lazygit

    neovim
    htop
  ];

  system.copySystemConfiguration = true;
  system.stateVersion = "24.11";

}

