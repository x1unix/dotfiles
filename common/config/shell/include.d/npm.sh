NPM_PREFIX="$HOME/.npm"
NPM_BIN_PATH="$HOME/.npm/bin"

export PATH="$PATH:$NPM_BIN_PATH"

# Preserve MANPATH if you already defined it somewhere in your config.
# Otherwise, fall back to `manpath` so we can inherit from `/etc/manpath`.
export MANPATH="${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man"

