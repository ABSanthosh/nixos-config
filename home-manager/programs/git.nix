{ pkgs, vars, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user.name = vars.git.userName;
      user.email = vars.git.userEmail;
      init.defaultBranch = "main";
      core = {
        # git config core.filemode false
        fileMode = false;
        autocrlf = false;
      };

      http = {
        postBuffer = 524288000; # 500MB
        version = "HTTP/1.1";
        sslVerify = false;
      };

      safe = {
        # https://git-scm.com/docs/git-config#Documentation/git-config.txt-safedirectory
        directory = "*";
      };
      credential.helper = "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret";
    };
  };
}
