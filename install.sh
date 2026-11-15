#!/usr/bin/env bash
# install.sh — Install the packages this niri config depends on.
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

# ── AUR helper detection ──────────────────────────────────────────────────────
AUR_HELPER=""
for helper in paru yay; do
    command -v "$helper" &>/dev/null && { AUR_HELPER="$helper"; break; }
done
[[ -z "$AUR_HELPER" ]] && warn "No AUR helper (paru/yay) found — AUR packages will be skipped."

# ── Package lists ─────────────────────────────────────────────────────────────

# Official repo packages (sudo pacman -S)
PACMAN_PKGS=(
    # Compositor
    niri                        # Wayland compositor; ships niri-session + session file

    # Desktop shell (bar, launcher, notifications, lockscreen, wallpaper, OSD)
    noctalia                    # CachyOS repo; AUR on plain Arch

    # Terminals
    alacritty                   # Mod+Return
    foot                        # spare terminal

    # Launchers / apps
    fuzzel                      # fallback launcher
    nautilus                    # Mod+E

    # X11 apps through XWayland (niri spawns the satellite itself)
    xwayland-satellite

    # Portals (file pickers, screen sharing)
    xdg-desktop-portal
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk

    # Polkit agent (started by xdg-desktop-autostart, not by niri)
    polkit-kde-agent

    # Audio stack (Noctalia volume/media controls)
    pipewire
    pipewire-pulse
    wireplumber

    # Media / screenshot / quality-of-life
    brightnessctl               # backlight + keyboard backlight
    playerctl                   # MPRIS (used by Noctalia media widget)
    wl-clipboard
    cliphist                    # clipboard history backend
    wlsunset                    # night light
    mako                        # fallback notification daemon
    swaybg                      # fallback wallpaper daemon

    # Look & feel
    capitaine-cursors
    adw-gtk-theme
    ttf-jetbrains-mono-nerd     # font used by the Alacritty theme
    noto-fonts
    noto-fonts-emoji
)

# AUR packages (only needed on distros without noctalia in their repos)
AUR_PKGS=()

if ! pacman -Si noctalia &>/dev/null; then
    warn "noctalia is not in your configured repos — it will come from the AUR."
    AUR_PKGS=( noctalia )
fi

# ── Install official packages ─────────────────────────────────────────────────
info "Installing official repo packages…"
sudo pacman -S --needed "${PACMAN_PKGS[@]}"
ok "Official packages done."

# ── Install AUR packages ──────────────────────────────────────────────────────
if ((${#AUR_PKGS[@]})); then
    if [[ -n "$AUR_HELPER" ]]; then
        info "Installing AUR packages with $AUR_HELPER…"
        "$AUR_HELPER" -S --needed "${AUR_PKGS[@]}"
        ok "AUR packages done."
    else
        warn "Skipping AUR packages (no helper found):"
        for pkg in "${AUR_PKGS[@]}"; do warn "  • $pkg"; done
        echo "  → Install paru: https://github.com/Morganamilo/paru"
    fi
fi

# ── Hardware-rendering drop-in (niri runs as a systemd user service) ───────────
# environment.d may carry COSMIC software-rendering workarounds; strip them for
# niri so the compositor uses the GPU.
DROPIN="$HOME/.config/systemd/user/niri.service.d/50-hardware-rendering.conf"
if [[ -d "$HOME/.config/environment.d" ]] && grep -qs 'LIBGL_ALWAYS_SOFTWARE' \
        "$HOME"/.config/environment.d/*.conf; then
    info "Writing niri.service hardware-rendering drop-in…"
    mkdir -p "$(dirname "$DROPIN")"
    cat >"$DROPIN" <<'CONF'
[Service]
UnsetEnvironment=LIBGL_ALWAYS_SOFTWARE EGL_SOFTWARE GALLIUM_DRIVER
CONF
    systemctl --user daemon-reload || true
    ok "Drop-in written: $DROPIN"
fi

# ── Summary ───────────────────────────────────────────────────────────────────
echo ""
echo "────────────────────────────────────────────────────"
ok "Installation complete!"
echo ""
echo "Next steps:"
echo "  1. Copy this config to ~/.config/niri (config.kdl + cfg/)."
echo "  2. Log out and pick 'Niri' at the greeter, or run 'niri-session' from a TTY."
echo "  3. Noctalia runs its setup wizard on first launch."
echo ""
echo "Do NOT autostart xwayland-satellite: niri 26.04 spawns it itself."
echo "Polkit/keyring come from /etc/xdg/autostart via xdg-desktop-autostart.target."
