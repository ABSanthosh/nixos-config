{ vars, ... }:
let
  generateBluetoothAliases =
    bluetooth:
    builtins.listToAttrs (
      builtins.map (name: {
        name = "blue-${bluetooth.${name}."command-name"}";
        value = ''bluetoothctl <<< "connect ${bluetooth.${name}.address}"'';
      }) (builtins.attrNames bluetooth)
    );
in
{
  programs.bash = {
    enable = true;
    initExtra = ''
      eval "$(starship init bash)"

      nix-vscode() {
        local NIXOS_DIR="/etc/nixos"
        local VSCODE_NIX="$NIXOS_DIR/pkgs/vscode.nix"

        local LATEST
        LATEST=$(curl -fsSL "https://update.code.visualstudio.com/api/releases/stable" \
          | jq -r '.[0]' 2>/dev/null)

        if [[ -z "$LATEST" || "$LATEST" == "null" ]]; then
          echo "Error: could not fetch latest VSCode version" >&2; return 1
        fi

        local CURRENT
        CURRENT=$(grep 'version = "' "$VSCODE_NIX" | head -1 \
          | sed 's/.*version = "\(.*\)".*/\1/')

        if [[ "$LATEST" == "$CURRENT" ]]; then
          echo "VSCode already at latest ($CURRENT)"; return 0
        fi

        echo "VSCode: $CURRENT → $LATEST, fetching hash..."
        local URL="https://update.code.visualstudio.com/$LATEST/linux-x64/stable"
        local SRI
        SRI=$(nix store prefetch-file --hash-type sha256 --json "$URL" 2>/dev/null \
          | jq -r '.hash')

        if [[ -z "$SRI" || "$SRI" == "null" ]]; then
          echo "Error: could not fetch VSCode hash" >&2; return 1
        fi

        python3 - "$VSCODE_NIX" "$LATEST" "$SRI" <<'EOF'
  import re, sys
  path, version, sri = sys.argv[1], sys.argv[2], sys.argv[3]
  txt = open(path).read()
  txt = re.sub(r'(version\s*=\s*)"[^"]*"', rf'\1"{version}"', txt, count=1)
  txt = re.sub(r'(x86_64-linux\s*=\s*)"sha256-[^"]*"', rf'\1"{sri}"', txt)
  open(path, "w").write(txt)
  EOF
        echo "Updated pkgs/vscode.nix → $LATEST"
        echo "Run nix-refresh to rebuild."
      }
    '';
    shellAliases =
      {
        nix-refresh = "sudo nixos-rebuild switch --flake .#${vars.user.host}";
        nix-garbage = "sudo nix-collect-garbage --delete-older-than 5d && nix-refresh";
        nix-list-generations = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
        nix-packages = "nix-store --query --requisites /run/current-system | cut -d- -f2- | sort -u | less";
        nix-update = "nix flake update";

        yy = "yazi";
        captive = "ip route show default | awk '{print $3}' | wl-copy";


        ".." = "cd ..";
        "..." = "cd ../../";
        "...." = "cd ../../../";
        "....." = "cd ../../../../";
        "......" = "cd ../../../../../";
      }
      // generateBluetoothAliases vars.bluetooth;
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
  };
}
