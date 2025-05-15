{ pkgs }:
pkgs.writeTextFile {
  name = "i3blocks-conf";
  destination = "/bin/i3blocks-conf";
  text = ''
    [brightness]
    command=./scripts/brightness.sh
    interval=persist
  '';
}
