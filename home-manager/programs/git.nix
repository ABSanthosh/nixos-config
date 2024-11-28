{ pkgs, vars, ... }: {
  programs.git = {
    enable = true;
    userName = vars.git.userName;
    userEmail = vars.git.userEmail;
    extraConfig = {
      user.name = vars.git.userName;
      user.email = vars.git.userEmail;
      init.defaultBranch = "main";
      core = {
        # git config core.filemode false   
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
