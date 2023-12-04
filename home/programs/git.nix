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
        core = {
          fileMode = false;
        };
        credential.helper = "${
          pkgs.git.override { withLibsecret = true; }
        }/bin/git-credential-libsecret";
      };
    };
  };
}
