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

modsecrets() {
  kfile="$HOME/.config/secrets.enc"
  keyid="$(grep fp "$kfile" | head -1 | cut -d':' -f2 | tr -d ' ",')"
  if [ -z "$keyid" ]; then
    echo "Error: cannot find PGP key ID"
    return 1
  fi

  tmpf="$(mktemp)"
  GPG_TTY=$(tty) sops --decrypt "$HOME/.config/secrets.enc" >"$tmpf"
  exit_code=$?
  if [ $exit_code -ne 0 ]; then
    rm -f "$tmpf"
    echo "🔑 Error: failed to decrypt secrets" >&2
    return $exit_code
  fi

  before=$(cksum <"$tmpf")
  editor="${EDITOR:-vim}"
  "$editor" "$tmpf"

  after=$(cksum <"$tmpf")
  if [ "$before" = "$after" ]; then
    rm -f "$tmpf"
    echo "File not changed, abort."
    return
  fi

  echo ":: Re-encrypting secrets using key '$keyid'..."
  GPG_TTY=$(tty) sops --encrypt --pgp "$keyid" "$tmpf" >"$kfile"
  exit_code=$?
  rm -f "$tmpf"
  if [ $exit_code -ne 0 ]; then
    echo "Error: failed to decrypt secrets" >&2
    return $exit_code
  fi
}
