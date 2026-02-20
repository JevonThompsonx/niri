#!/usr/bin/env bash
# install.sh — Install all dependencies for this niri config
# Targets Arch Linux and derivatives (CachyOS, EndeavourOS, Manjaro, etc.)

set -euo pipefail

# ── Colors ───────────────────────────────────────────────────────────────────
BLUE='\033[0;34m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
info()    { echo -e "${BLUE}==${NC} $*"; }
ok()      { echo -e "${GREEN}✓${NC} $*"; }
warn()    { echo -e "${YELLOW}!${NC} $*"; }
die()     { echo -e "${RED}✗${NC} $*" >&2; exit 1; }

# ── Sanity checks ─────────────────────────────────────────────────────────────
command -v pacman &>/dev/null || die "pacman not found — run this on Arch Linux or a derivative."
command -v git    &>/dev/null || die "git is required. Install it with: sudo pacman -S git"

# ── AUR helper detection ──────────────────────────────────────────────────────
AUR_HELPER=""
for helper in yay paru; do
    command -v "$helper" &>/dev/null && { AUR_HELPER="$helper"; break; }
done
[[ -z "$AUR_HELPER" ]] && warn "No AUR helper (yay/paru) found — AUR packages will be skipped."

# ── Package lists ─────────────────────────────────────────────────────────────

# Official repo packages (sudo pacman -S)
PACMAN_PKGS=(
    # Compositor
    niri                        # Wayland tiling compositor

    # Terminals
    alacritty                   # Mod+Shift+Return
    foot                        # Mod+Return

    # App launcher
    fuzzel                      # Mod+D (dmenu-style Wayland launcher)

    # File manager
    nautilus                    # Mod+E (GNOME Files)

    # Browser — uncomment if you prefer the open-source build
    # chromium

    # Media / screen capture
    obs-studio                  # window-rule defined for com.obsproject.Studio

    # Polkit agent (autostart: /usr/lib/polkit-kde-authentication-agent-1)
    polkit-kde-agent

    # Audio stack (noctalia-shell volume/media controls)
    pipewire
    pipewire-pulse
    wireplumber

    # Portal backend (screen sharing, file pickers)
    xdg-desktop-portal
    xdg-desktop-portal-gnome    # niri-compatible portal impl
)

# AUR packages (require yay / paru)
AUR_PKGS=(
    brave-bin                   # Mod+B — Brave browser (window-rule: brave-browser)
    nwg-drawer                  # Mod+Shift+D — grid app drawer
    quickshell-git              # provides the `qs` binary used by noctalia-shell
)

# ── Install official packages ─────────────────────────────────────────────────
info "Installing official repo packages…"
sudo pacman -S --needed "${PACMAN_PKGS[@]}"
ok "Official packages done."

# ── Install AUR packages ──────────────────────────────────────────────────────
if [[ -n "$AUR_HELPER" ]]; then
    info "Installing AUR packages with $AUR_HELPER…"
    "$AUR_HELPER" -S --needed "${AUR_PKGS[@]}"
    ok "AUR packages done."
else
    warn "Skipping AUR packages (no helper found). Install manually:"
    for pkg in "${AUR_PKGS[@]}"; do
        warn "  • $pkg"
    done
    echo "  → Install yay: https://github.com/Jguer/yay"
    echo "     or paru:     https://github.com/Morganamilo/paru"
    echo "  Then re-run this script."
fi

# ── noctalia-shell ────────────────────────────────────────────────────────────
# noctalia-shell is the Quickshell-based UI layer providing:
#   volume, brightness, media controls, lock screen, and session menu.
# autostart.kdl launches it as: qs -c noctalia-shell
#
# Install from: https://docs.noctalia.dev/getting-started/installation/
#
info "Checking for noctalia-shell…"
if command -v qs &>/dev/null; then
    if qs --list 2>/dev/null | grep -q "noctalia-shell" || \
       [[ -d "$HOME/.config/noctalia-shell" ]]; then
        ok "noctalia-shell appears to be present."
    else
        warn "quickshell (qs) found, but noctalia-shell config not detected."
        warn "Follow the install guide: https://docs.noctalia.dev/getting-started/installation/"
    fi
else
    warn "quickshell (qs) not installed yet — install quickshell-git from AUR first,"
    warn "then follow: https://docs.noctalia.dev/getting-started/installation/"
fi

# ── Summary ───────────────────────────────────────────────────────────────────
echo ""
echo "────────────────────────────────────────────────────"
ok "Installation complete!"
echo ""
echo "Apps accounted for:"
echo "  niri              — compositor"
echo "  alacritty, foot   — terminals (Mod+Shift+Return / Mod+Return)"
echo "  fuzzel            — launcher (Mod+D)"
echo "  nwg-drawer        — app drawer (Mod+Shift+D)"
echo "  brave-bin         — browser (Mod+B)"
echo "  nautilus          — file manager (Mod+E)"
echo "  obs-studio        — screen recorder (window-rule)"
echo "  polkit-kde-agent  — auth agent (autostart)"
echo "  quickshell (qs)   — noctalia-shell runtime (autostart)"
echo "  pipewire stack    — audio/media controls"
echo "  xdg-desktop-portal-gnome — screen share / file pickers"
echo ""
echo "Start niri from a TTY with: niri-session"
