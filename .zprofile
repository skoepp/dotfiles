# Homebrew implementation - requires the installation of Homebrew - see https://brew.sh/
eval "$(/opt/homebrew/bin/brew shellenv)"

# Load dotfiles like ~/.aliases, etc…
#   ~/.extra can be used for settings you don’t want to commit
#   Use it to configure your PATH, thus it being first in line.
#
# For file in ~/.{extra, exports, aliases}; do
for file in ~/.{extra,exports,aliases}; do
    [ -r "$file" ] && source "$file"
done
unset file

# User specific environment and startup programs
PATH=$PATH:$HOME/.local/bin:$HOME/bin
export PATH