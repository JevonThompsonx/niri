# niri config — pan (MacBookPro14,3, CachyOS)

Modular niri configuration with the Noctalia shell. Keybindings are the core of
this repo; everything else is tuned for `pan`.

## Files

| File | Description |
|------|-------------|
| `config.kdl` | Includes every module below |
| `cfg/keybinds.kdl` | All keyboard shortcuts |
| `cfg/autostart.kdl` | Startup apps (Noctalia) |
| `cfg/display.kdl` | Output config (single `eDP-1` on pan) |
| `cfg/input.kdl` | Keyboard, Apple touchpad, mouse |
| `cfg/layout.kdl` | Gaps, focus ring, shadow, blur, overview |
| `cfg/animation.kdl` | Window/workspace animation curves |
| `cfg/rules.kdl` | Window/layer rules (radius, blur, backdrop) |
| `cfg/misc.kdl` | Environment vars, screenshots, CSD, hotkey overlay |

## Hardware notes (pan)

- **Panel:** the internal 2880x1800 display is wired to the AMD GPU and shows up
  as `eDP-1` on the amdgpu card (the Intel iGPU's eDP link is disabled by i915).
  `display.kdl` therefore configures `eDP-1` only and runs at `scale 1.5`
  (= 1920x1200 logical).
- **Backlight:** `gmux_backlight`; `brightnessctl` and Noctalia both drive it.
- **Keyboard backlight:** `spi::kbd_backlight` (Apple SPI keyboard).
- **Function keys:** `hid_apple fnmode` is `3`, so F1/F2/F10–F12 emit the
  `XF86*` media keys the binds expect. To swap to plain F-keys at runtime:
  `echo 2 | sudo tee /sys/module/hid_apple/parameters/fnmode`.
- **Rendering:** `~/.config/environment.d/cosmic-software.conf` forces llvmpipe
  for the systemd user manager (a COSMIC workaround). niri runs as a user
  service and would inherit it, so a unit drop-in strips those variables:
  `~/.config/systemd/user/niri.service.d/50-hardware-rendering.conf`.
- **XWayland:** niri 26.04 spawns `xwayland-satellite` itself; do not autostart it.

## Starting a session

`niri` ships `/usr/share/wayland-sessions/niri.desktop`, so it appears at the
COSMIC greeter (`cosmic-greeter` / greetd) alongside COSMIC. Pick **Niri** and
log in. From a TTY, `niri-session` does the same thing.

Always use `niri-session` (or the greeter), not bare `niri`: the session unit is
what pulls in `xdg-desktop-autostart.target` (polkit agent, gnome-keyring) and
the hardware-rendering drop-in.

## Key Bindings

Mod = Super.

### Applications
| Binding | Action |
|---------|--------|
| `Mod+Return` | Terminal (Alacritty) |
| `Mod+B` | Browser (Firefox) |
| `Mod+E` | File manager (Nautilus) |
| `Mod+Shift+K` | Google Keep (Firefox window) |
| `Mod+Shift+A` | opencode in Alacritty |

### Noctalia
| Binding | Action |
|---------|--------|
| `Mod+D`, `Mod+Space`, `Mod+Ctrl+Return` | App launcher |
| `Mod+S` | Control center |
| `Mod+Shift+S` | Noctalia settings |
| `Mod+Shift+Return` | Wallpaper picker |
| `Mod+Alt+L` | Lock screen |
| `Mod+Shift+Q` | Session menu |
| `Alt+Tab` / `Alt+Shift+Tab` | Window switcher (forward/reverse) |

### Window Management
| Binding | Action |
|---------|--------|
| `Mod+Q` | Close window |
| `Mod+T` | Toggle floating |
| `Mod+F` | Toggle maximize column ↔ tiled (keeps gaps) |
| `Mod+Shift+F` | Toggle fullscreen (no gaps, bar hidden) |
| `Mod+M` | Toggle maximize to edges |
| `Mod+W` | Toggle tabbed column |
| `Mod+C` / `Mod+Ctrl+C` | Center column / all visible columns |
| `Mod+Ctrl+F` | Expand column to available width |
| `Mod+Minus`/`Mod+Equal` | Resize column width ±10% |
| `Mod+Shift+Minus`/`Mod+Shift+Equal` | Resize window height ±10% |
| `Mod+Shift+V` | Focus floating/tiling |

### Focus & Movement
| Binding | Action |
|---------|--------|
| `Mod+H/J/K/L` or arrows | Focus left/down/up/right |
| `Mod+Ctrl+H/J/K/L` or arrows | Move column/window |
| `Mod+Shift+arrows` | Move window up/down in column, column left/right |
| `Mod+Shift+Ctrl+arrows` | Move column to monitor |
| `Mod+Home`/`Mod+End` | Focus first/last column |
| `Mod+Tab` | Previous workspace |
| `Mod+1…9` | Focus workspace |
| `Mod+Shift+1…9` | Move focused column to workspace |
| `Mod+Ctrl+1…9` | Move column to workspace (same as above) |

### Screenshots & System
| Binding | Action |
|---------|--------|
| `Ctrl+Shift+1` | Region screenshot (niri UI) |
| `Ctrl+Shift+2` | Full screen |
| `Ctrl+Shift+3` | Window |
| `Mod+Shift+Escape` | Hotkey overlay |
| `Mod+O` | Overview |
| `Mod+Escape` | Toggle keyboard-shortcut inhibit |
| `Mod+Shift+P` | Power off monitors |
| `Ctrl+Alt+Delete` | Quit niri |

Screenshots land in `~/Pictures/Screenshots/` and are copied to the clipboard.

### Media / brightness (Apple keyboard)
| Key | Action |
|-----|--------|
| `XF86Audio*` | Volume, mute, mic mute, play/next/prev via Noctalia |
| `XF86MonBrightnessUp/Down` | Panel brightness (`gmux_backlight`) |
| `XF86KbdBrightnessUp/Down` | Keyboard backlight (`spi::kbd_backlight`) |

## Input
- Keyboard: US layout, numlock on
- Touchpad: tap, drag, drag-lock, dwt/dwtp, natural scroll, adaptive accel
- Mouse: flat accel, -0.5 speed
- Focus follows mouse (only for fully visible windows), cursor hides after 1s

## Install

```sh
./install.sh
```

Packages are pulled from the CachyOS repos (`niri`, `noctalia`). On plain Arch,
`niri` is in `extra` and `noctalia` is in the AUR.
