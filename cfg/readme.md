# niri config

Modular niri config split across multiple `.kdl` files.

## Files

| File | Description |
|------|-------------|
| `keybinds.kdl` | All keyboard shortcuts |
| `autostart.kdl` | Startup apps (Polkit, noctalia-shell) |
| `display.kdl` | Monitor layout (4 displays) |
| `input.kdl` | Keyboard, touchpad, mouse settings |
| `layout.kdl` | Gap, column widths, background |
| `animation.kdl` | Window/workspace animation curves |
| `rules.kdl` | Window rules (rounded corners, maximize rules) |
| `misc.kdl` | Environment vars, CSD, hotkey overlay |

## Display Layout

| Output | Resolution | Scale | Position |
|--------|-----------|-------|----------|
| DP-5 | 1920x1080@60 | 1x | Left (0,0) |
| DP-4 | 1920x1080@60 | 1x | Center (1920,0) |
| DP-3 | 1920x1080@60 | 1x | Right (3840,0) |
| eDP-1 | 2560x1600@165 | 1.5x | Laptop, below center (2026,1080) |

## Key Bindings

### Applications
| Binding | Action |
|---------|--------|
| `Mod+Return` | Terminal (foot) |
| `Mod+Shift+Return` | Terminal (alacritty) |
| `Mod+D` | App launcher (fuzzel) |
| `Mod+B` | Browser (Brave) |
| `Mod+E` | File manager (Nautilus) |
| `Mod+L` | Lock screen |
| `Mod+Shift+E` | Session menu |

### Window Management
| Binding | Action |
|---------|--------|
| `Mod+Q` | Close window |
| `Mod+T` | Toggle floating |
| `Mod+F` | Fullscreen |
| `Mod+W` | Toggle tabbed column |
| `Mod+C` | Center column |
| `Mod+Ctrl+C` | Center all visible columns |
| `Mod+Ctrl+F` | Expand column to full width |
| `Mod+Minus/Equal` | Resize column width ±10% |
| `Mod+Shift+Minus/Equal` | Resize window height ±10% |

### Focus & Movement
| Binding | Action |
|---------|--------|
| `Mod+H/J/K/L` or arrows | Focus left/down/up/right |
| `Mod+Ctrl+H/J/K/L` or arrows | Move window left/down/up/right |
| `Mod+Shift+arrows` | Focus monitor |
| `Mod+Shift+Ctrl+arrows` | Move column to monitor |
| `Mod+Home/End` | Focus first/last column |
| `Mod+Tab` | Previous workspace |
| `Mod+1–9` | Switch to workspace |
| `Mod+Shift+1–9` | Move column to workspace |

### Screenshots
| Binding | Action |
|---------|--------|
| `Ctrl+S` | Region screenshot |
| `Ctrl+Shift+S` | Full screen screenshot |
| `Ctrl+Shift+3` | Window screenshot |

### System
| Binding | Action |
|---------|--------|
| `Mod+Shift+Escape` | Hotkey overlay |
| `Mod+O` | Toggle overview |
| `Mod+Escape` | Toggle keyboard shortcut inhibit |
| `Mod+Shift+P` | Power off monitors |
| `Ctrl+Alt+Delete` | Quit niri |

## Input
- Keyboard: US layout, numlock on
- Touchpad: tap-to-click, natural scroll
- Mouse: flat accel, -0.5 speed
- Focus follows mouse, cursor hides after 1s / when typing
