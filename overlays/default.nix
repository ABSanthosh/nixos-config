{ inputs, ... }:
{
  # This one brings our custom packages from the 'pkgs' directory
  # additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  # modifications = final: prev: {
  # example = prev.example.overrideAttrs (oldAttrs: rec {
  # ...
  # });
  # };

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
}
