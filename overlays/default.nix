{ inputs, ... }:
{
  vscode-custom = final: _prev: {
    vscode-custom = final.callPackage ../pkgs/vscode.nix { };
  };

  patched-phinger-cursors = final: prev: {
    phinger-cursors = prev.phinger-cursors.overrideAttrs (old: {
      postInstall = ''
        ${old.postInstall or ""}

        for theme in $out/share/icons/phinger-cursors*; do
          themefile="$theme/index.theme"
          if [ -f "$themefile" ]; then
            echo "Patching $themefile"

            # Replace invalid name
            sed -i 's/^Name=.*$/Name=Phinger-Cursors-Light/' "$themefile"

            grep -q '^Comment=' "$themefile" || \
              sed -i '/^\[Icon Theme\]/a Comment=Phinger Cursor Theme' "$themefile"

            grep -q '^Directories=' "$themefile" || \
              echo "Directories=cursors" >> "$themefile"

            mkdir -p "$theme/cursors"
          fi
        done
      '';
    });
  };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  old-packages = final: _prev: {
    old = import inputs.nixpkgs-old {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
