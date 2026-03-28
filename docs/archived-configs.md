# Archived Configurations

Configs that were removed from source files to reduce noise. Git history
preserves the full text; this file explains what each was and why it was removed.

---

## XDG Portal (old variants) — `nixos/modules/desktop-env/sway.nix`

Two older XDG portal configs were commented out. Both were superseded by the
simpler active config that uses `xdg.portal.wlr.enable = true`.

**Variant 1** (had explicit screencast chooser via slurp):
```nix
xdg.portal = {
  enable = true;
  wlr.enable = true;
  wlr.settings.screencast = {
    output_name = "eDP-1";
    chooser_type = "simple";
    chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
  };
  extraPortals = with pkgs; [
    xdg-desktop-portal
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk
  ];
  config.common.default = [ "wlr" ];
};
```

**Variant 2** (wlr with screencast settings, no gtk portal):
```nix
xdg.portal = {
  config.common.default = [ "wlr" ];
  wlr.enable = true;
  wlr.settings.screencast = {
    output_name = "eDP-1";
    chooser_type = "simple";
    chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
  };
};
```

If screencast via portals breaks, re-adding the `wlr.settings.screencast`
block with a `chooser_cmd` pointing to slurp is the fix.

Git ref: configs existed prior to `1f6c8cc`.

---

## Gammastep — `home-manager/home.nix`

Blue-light filter service. Disabled because lat/lon were placeholders.

```nix
services.gammastep = {
  enable = true;
  provider = "manual";
  latitude = 49.0;
  longitude = 8.4;
};
```

To re-enable: add back to `home.nix` services block with correct coordinates.
The home-manager `services.gammastep` module handles the systemd unit.

---

## Prisma Engine Binaries — `nixos/modules/env.nix`

Prisma ORM requires engine binaries that don't match the ones bundled with
`prisma` npm package on NixOS. These env vars point prisma at the NixOS-built
binaries.

```nix
environment.sessionVariables = {
  PRISMA_SCHEMA_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/migration-engine";
  PRISMA_QUERY_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/query-engine";
  PRISMA_QUERY_ENGINE_LIBRARY = "${pkgs.prisma-engines}/lib/libquery_engine.node";
  PRISMA_INTROSPECTION_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/introspection-engine";
  PRISMA_FMT_BINARY = "${pkgs.prisma-engines}/bin/prisma-fmt";
  PRISMA_ENGINES_CHECKSUM_IGNORE_MISSING = "1";
};
```

To re-enable: uncomment in `env.nix` and add `pkgs.prisma-engines` to system
packages or the relevant dev shell. Also add `prisma-engines` to pkgs args.

Git ref: introduced around `6a1ec87`.

---

## Swaybar / swaybar-cmd — `home-manager/desktop-env/sway/default.nix`

An alternative status bar implementation using a custom `swaybar-cmd` nix
package was explored before settling on i3blocks.

```nix
# swaybar-cmd = pkgs.callPackage ./swaybar/swaybar-cmd.nix { };
# statusCommand = "${swaybar-cmd}/bin/swaybar-cmd";
```

The `./swaybar/` directory and `swaybar-cmd.nix` package were removed
separately. i3blocks with the scripts in `./i3blocks/scripts/` is the
current approach.

---

## MySQL / PostgreSQL Services — `nixos/modules/services/`

Both database modules exist but are not imported in `services/default.nix`.

- `nixos/modules/services/database/mysql.nix` — MySQL 8.0 service
- `nixos/modules/services/database/postgres.nix` — PostgreSQL service

To enable either: uncomment the relevant import in
`nixos/modules/services/default.nix`.

---

## Tailscale Auth Key — `nixos/modules/services/tailscale.nix`

⚠️ **Security note:** A plaintext Tailscale auth key was hardcoded in this
file. The key has been revoked. The file (`tailscale.nix`) is not imported
but remains in the tree as a reference.

Before re-enabling Tailscale, move the auth key to a sops secret:

1. Add to `secrets.yaml`: `tailscale_auth_key: <key>`
2. Reference it in the service script via `${config.sops.secrets.tailscale_auth_key.path}`

Git ref: tailscale service introduced in `6a1ec87`.
