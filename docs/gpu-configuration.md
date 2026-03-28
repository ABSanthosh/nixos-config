# GPU Configuration

This machine uses a hybrid Intel + NVIDIA setup. Intel is the primary GPU for
daily use; NVIDIA is available on-demand via PRIME offload.

## Current Setup (Intel-only)

`nixos/modules/gpu/intel.nix` — just enables `hardware.graphics` with 32-bit
support. Intel's `i915` driver loads automatically; no explicit driver
declaration is needed.

`configuration.nix` imports:
```nix
./modules/gpu/intel.nix
# ./modules/gpu/nvidia.nix  ← commented out
```

## Re-enabling NVIDIA (nvidia.nix)

`nixos/modules/gpu/nvidia.nix` is the current NVIDIA config. Key settings:

| Option | Value | Why |
|--------|-------|-----|
| `nvidia.open` | `false` | Use proprietary driver (better performance/power management) |
| `nvidia.modesetting.enable` | `true` | Required for PRIME offload |
| `nvidia.powerManagement.enable` | `true` | Runtime power management |
| `nvidia.powerManagement.finegrained` | `true` | NVIDIA GPU powers down when idle |
| `prime.offload.enable` | `true` | NVIDIA used only when explicitly requested |
| `prime.offload.enableOffloadCmd` | `true` | Provides `nvidia-offload` wrapper script |
| `intelBusId` | `PCI:0:2:0` | From `lspci` — Intel UHD |
| `nvidiaBusId` | `PCI:1:0:0` | From `lspci` — NVIDIA discrete GPU |
| `WLR_DRM_DEVICES` | `/dev/dri/card1` | Forces Sway to use Intel, not NVIDIA |
| `videoDrivers` | `["modesetting", "nvidia"]` | Intel/modesetting first so X stays on Intel |

To run something on NVIDIA: `nvidia-offload <command>`

To re-enable: uncomment `./modules/gpu/nvidia.nix` in `configuration.nix`.

## Git History

- **`80fe9c6`** — `feat: enable NVIDIA support with updated configurations for offloading and power management` — last commit where nvidia.nix was actively imported
- **`1f6c8cc`** — `feat: update flake.lock and flake.nix for NixOS 25.11, add support for old Nixpkgs and Lutris, enhance GPU configuration for Intel and NVIDIA` — nvidia.nix commented out, intel-only config settled
- **`0c06560`** — `feat: update GPU configuration for Intel and NVIDIA support, add nvidia-offload script, and refine udev rules` — earlier nvidia offload iteration
- **`487cd29`** — `chore: added nvidia offload` — original nvidia-offload script

## The .bk.nix Files (now deleted)

`nvidia.bk.nix` was an older nvidia config variant that used a `gpuDriver`
variable to toggle between proprietary nvidia and nouveau at config time.
It was superseded by the simpler `nvidia.nix`. Removed in cleanup commit.

`intel.bk.nix` was an empty placeholder. Removed in cleanup commit.
