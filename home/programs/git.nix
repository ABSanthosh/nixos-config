{ pkgs, config, ... }:

{
  programs = {
    git = {
      enable = true;
      userName = "ABSanthosh";
      userEmail = "a.b.santhosh02@gmail.com";
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
      };
    };
  };
}
