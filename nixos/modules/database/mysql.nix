{ config, lib, pkgs, ... }:

{
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    # To configure the database, run the following
    # [nix-shell:~]$ mysql
    # mysql> select password('<password>');
    # +-------------------------------------------+
    # | password("Ranchero0")                     |
    # +-------------------------------------------+
    # | *432C338E13B8D7FB08E225BECBD0C0959CF98292 |
    # +-------------------------------------------+

    # [nix-shell:~]$ sudo mysql_secure_installation
    # then paste the above password and follow the instructions
  };
}
