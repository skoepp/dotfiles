# Load dotfiles (aliases, exports, etc.)
for file in ~/.{extra,exports,aliases}; do
    [ -r "$file" ] && source "$file"
done
unset file
