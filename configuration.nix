{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./modules/ssh.nix
      ./modules/user.nix
      ./modules/git/git.nix
      ./modules/git/legit.nix
#      ./modules/git/cgit.nix
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
      ./modules/jellyfin.nix
      ./modules/glance.nix
    ];

  nix.settings.experimental-features = "nix-command flakes";

  networking.hostName = "nosix";
  time.timeZone = "Europe/Berlin";
  networking.firewall.enable = true;

  environment.systemPackages = with pkgs; [
    jq
    git
    lazygit

    neovim
  ];

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.11";
}

