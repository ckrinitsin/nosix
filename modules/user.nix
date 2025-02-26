{ config, libs, pkgs, ... }:
{

  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJZxiAIsF13XqqxG0QzGFhT3iLDMsu2snb0wJOPUUq8e chris@deskpin" "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDwlqdl/70dJ1ABKwLEdLB6/RDpfE4RVaB+xL3YJ1v3+ chris@kingpin" ];
  };
  security.sudo.wheelNeedsPassword = false;

}
