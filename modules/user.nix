{ config, libs, pkgs, ... }:
{

  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [ 
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBi+VYFQOfb7J2eJd8CiXKcaLD+QfztXiS2pU07oHZNr chris@archiso"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDwlqdl/70dJ1ABKwLEdLB6/RDpfE4RVaB+xL3YJ1v3+ chris@kingpin"
    ];
  };
  security.sudo.wheelNeedsPassword = false;

}
