# Homebrew — login shell only (macOS terminals are login shells;
# child shells inherit the exported env vars from the parent)
[ -r "$HOME/.homebrew_env" ] && source "$HOME/.homebrew_env"
