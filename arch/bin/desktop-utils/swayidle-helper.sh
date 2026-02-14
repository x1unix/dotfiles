#!/usr/bin/env sh
set -e

# Helper to handle swayidle events based on current Wayland compositor.
# Used to keep a single config for swayidle between different WMs.

# WM-specific methods
niri_suspend() {
  niri msg action power-off-monitors
}

niri_resume() {
  niri msg action power-on-monirors
}

sway_suspend() {
  swaymsg "output * power off"
}

sway_resume() {
  swaymsg "output * power on"
}

hyprland_resume() {
  hyprctl dispatch dpms off
}

hyprland_suspend() {
  hyprctl dispatch dpms on
}

# Main logic

G_LOGDIR="$HOME/.local/share/log"
G_LOGFILE="$G_LOGDIR/swayidle-helper.log"

die() {
  mkdir -p "$G_LOGDIR"
  printf "ERROR: %s\n" "$1" | tee "$G_LOGFILE"
  exit 1
}

g_suspend() {
  case "$XDG_CURRENT_DESKTOP" in
  niri | sway | hyprland)
    "${XDG_CURRENT_DESKTOP}_suspend"
    ;;
  *)
    die "unsupported desktop: $XDG_CURRENT_DESKTOP"
    ;;
  esac
}

g_resume() {
  case "$XDG_CURRENT_DESKTOP" in
  niri | sway | hyprland)
    "${XDG_CURRENT_DESKTOP}_resume"
    ;;
  *)
    die "unsupported desktop: $XDG_CURRENT_DESKTOP"
    ;;
  esac
}

g_lock() {
  if [ -n "$SWAYIDLE_USE_LOGINCTL" ]; then
    loginctl lock-session
  else
    swaylock
  fi
}

if [ -z "$XDG_CURRENT_DESKTOP" ]; then
  die "missing env var XDG_CURRENT_DESKTOP"
fi

if [ -z "$1" ]; then
  echo "Usage: $0 [suspend|resume]"
  die "missing subcommand"
fi

case "$1" in
suspend)
  g_suspend
  ;;
resume)
  g_resume
  ;;
lock)
  g_lock
  ;;
*)
  echo "Usage: $0 [suspend|resume|lock]"
  die "bad subcommand '$1'"
  ;;
esac
