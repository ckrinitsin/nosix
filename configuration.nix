{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";

  networking.hostName = "nixos";

  time.timeZone = "Europe/Berlin";

  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJZxiAIsF13XqqxG0QzGFhT3iLDMsu2snb0wJOPUUq8e chris@deskpin" ];
  };

  environment.systemPackages = with pkgs; [
    neovim    git
    openssh
  ];

  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  security.sudo.wheelNeedsPassword = false;

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];
  networking.firewall.allowedUDPPorts = [ ];

  system.copySystemConfiguration = true;
  system.stateVersion = "24.11";

}

