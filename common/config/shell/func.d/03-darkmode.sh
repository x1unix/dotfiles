darkmodecmd='tell app "System Events" to tell appearance preferences to set dark mode to not dark mode'

_GTK_THEME_KS='org.gnome.desktop.interface'
darkmode_gtk() {
  current="$(gsettings get "$_GTK_THEME_KS" color-scheme)"
  new_val='prefer-dark'
  if [ "$current" = "'$new_val'" ]; then
    new_val='default'
  fi

  gsettings set "$_GTK_THEME_KS" color-scheme "$new_val"
}

darkmode_macos() {
  osascript -e '$darkmodecmd'
}

darkmode() {
  case "$(uname -s)" in
    Darwin)
      darkmode_macos
      ;;
    Linux)
      darkmode_gtk
      ;;
    *)
      echo "Error: unsupported platform: $(uname -s)"
      exit 1
      ;;
    esac
}

