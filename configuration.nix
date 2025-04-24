{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./modules/ssh.nix
      ./modules/user.nix
      ./modules/git/git.nix
      ./modules/git/cgit.nix
      ./modules/minecraft-server.nix
      ./modules/webserver.nix
      ./modules/syncthing.nix
      ./modules/mailserver.nix
      ./modules/matrix/matrix.nix
      ./modules/mealie.nix
      ./modules/polaris.nix
      ./modules/caldav.nix
      ./modules/vaultwarden.nix
      ./modules/pdf.nix
      ./modules/atuin.nix
      ./modules/silverbullet.nix
      ./modules/monit.nix
      ./modules/shopping-list.nix
      ./modules/glance.nix
    ];

  networking.hostName = "nixos";
  time.timeZone = "Europe/Berlin";
  networking.firewall.enable = true;

  environment.systemPackages = with pkgs; [
    jq
    git
    lazygit

    neovim
  ];

  system.copySystemConfiguration = true;
  system.stateVersion = "24.11";

}

