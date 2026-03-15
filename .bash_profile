# PATH additions needed everywhere (scripts, IDEs, subprocesses)
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# Homebrew — login shell only
[ -r "$HOME/.homebrew_env" ] && source "$HOME/.homebrew_env"
