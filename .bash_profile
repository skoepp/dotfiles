# Homebrew — requires the installation of Homebrew - see https://brew.sh/
[ -r "$HOME/.homebrew_env" ] && source "$HOME/.homebrew_env"

# Load dotfiles like ~/.aliases, etc…
#   ~/.extra can be used for settings you don’t want to commit
#   Use it to configure your PATH, thus it being first in line.
#
# For file in ~/.{extra, exports, aliases}; do
for file in ~/.{extra,exports,aliases}; do
    [ -r "$file" ] && source "$file"
done
unset file

# z from github.com/rupa/z
source ~/code/z/z.sh

# User specific environment and startup programs
PATH=$PATH:$HOME/.local/bin:$HOME/bin
export PATH
