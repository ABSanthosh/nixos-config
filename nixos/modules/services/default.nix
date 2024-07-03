{config, pkgs, lib, ...}: 
{
    services = {
        xserver = {
        enable = true;
        excludePackages = [ pkgs.xterm ];

        # Enable automatic login for the user.
        getty.autologinUser = "santhosh";

        xkb = {
            layout = "us";
            variant = "";
        };
        };

        # Enable CUPS to print documents.
        printing.enable = false;
        avahi = {
        enable = true;
        nssmdns4 = true;
        };

        # Enable the OpenSSH daemon.
        openssh.enable = true;
    };
}