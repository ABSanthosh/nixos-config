# Self-maintained VSCode package.
# Run `nix-vscode` in your shell to auto-update version + hash, then `nix-refresh`.
{
  stdenv,
  fetchurl,
  unstable,
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  # ── UPDATE THESE TWO FIELDS ─────────────────────────────────────────────────
  version = "1.113.0";

  hashes = {
    x86_64-linux   = "sha256-p+8hlq6eB/d3oyPMirJ4ZRqY65xQyEk0jc8k2FiduuY=";
    aarch64-linux  = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    x86_64-darwin  = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    aarch64-darwin = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };
  # ────────────────────────────────────────────────────────────────────────────

  plat = {
    x86_64-linux   = "linux-x64";
    aarch64-linux  = "linux-arm64";
    x86_64-darwin  = "darwin";
    aarch64-darwin = "darwin-arm64";
    armv7l-linux   = "linux-armhf";
  }.${system} or throwSystem;

  archive_fmt = if stdenv.hostPlatform.isDarwin then "zip" else "tar.gz";

in
unstable.vscode.overrideAttrs (_old: {
  inherit version;
  src = fetchurl {
    name = "VSCode_${version}_${plat}.${archive_fmt}";
    url = "https://update.code.visualstudio.com/${version}/${plat}/stable";
    hash = hashes.${system} or throwSystem;
  };
})
