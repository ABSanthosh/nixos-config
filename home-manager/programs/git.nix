{ pkgs, config, ... }:

{
  programs.git = {
    enable = true;
    userName = "ABSanthosh";
    userEmail = "a.b.santhosh02@gmail.com";
    config = {
      user.name = "ABSanthosh";
      user.email = "a.b.santhosh02@gmail.com";
    };
    extraConfig = {
      init.defaultBranch = "main";
      core = {
        fileMode = false;
        autocrlf = false;
      };
      safe = {
        # https://git-scm.com/docs/git-config#Documentation/git-config.txt-safedirectory
        directory = "*"; 
      };
      credential.helper = "${
          pkgs.git.override { withLibsecret = true; }
        }/bin/git-credential-libsecret";
    };
  };
}
