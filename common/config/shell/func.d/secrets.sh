#!/usr/bin/env sh

loadsecrets() {
  result=$(GPG_TTY=$(tty) sops --decrypt "$HOME/.config/secrets.enc")
  exit_code=$?
  if [ $exit_code -ne 0 ]; then
    echo "🔑 Error: failed to decrypt secrets" >&2
    return $exit_code
  fi

  eval "$result"
  echo "🔑 Secrets loaded successfully"
}

