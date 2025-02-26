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
    ];

  networking.hostName = "nixos";
  time.timeZone = "Europe/Berlin";
  networking.firewall.enable = true;

  environment.systemPackages = with pkgs; [
    git
    neovim
    openssh
    htop
    lazygit

    python312
    python312Packages.flask
  ];

  system.copySystemConfiguration = true;
  system.stateVersion = "24.11";

}

