export SHELL_RES="$HOME/.local/shell"
export LOCAL="$HOME/.local"

AUTOLOAD_FILE="$SHELL_RES/.autoload.sh"

shell_source() {
  if [ -f "$!" ]; then
    . "$!"
  fi
}

shell_path() {
  if [ ! -d "$1" ]; then
    return 0
  fi

  PATH="$PATH:$1"
  export PATH
}

shell_unload() {
  unset -f shell_path
  unset -f shell_source
  unset -f shell_unload
  unset -f shell_load
  unset AUTOLOAD_FILE
}

shell_load() {
  if [ ! -d "$SHELL_RES" ]; then
    echo "Directory $SHELL_RES not found, skip load"
    return
  fi

  shell_path "$SHELL_RES/bin"
  if [ ! -f "$AUTOLOAD_FILE" ]; then
    echo "_ Autoload file not found, generating..."
    shmgr gen
  fi
  . "$AUTOLOAD_FILE"
  shell_unload
}

shell_load
