#!/bin/bash

# install.sh - Interactive dotfiles installer
# Manages symlinks, backups, and rollback for dotfiles

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup"
SHELL_CHOICE_FILE="$BACKUP_DIR/.shell_choice"

# Dotfiles shared by both shells
SHARED_FILES=".aliases .dircolors .exports .gitattributes .gitconfig .gitignore .profile .vimrc"

# Shell-specific dotfiles
ZSH_FILES=".zprofile .zshrc"
BASH_FILES=".bash_profile .bashrc"

# --- Helper functions ---

print_header() {
    echo ""
    echo "dotfiles installer"
    echo "────────────────────"
    echo ""
}

print_separator() {
    echo "────────────────────"
}

get_shell_files() {
    local shell="$1"
    if [ "$shell" = "zsh" ]; then
        echo "$ZSH_FILES"
    else
        echo "$BASH_FILES"
    fi
}

get_other_shell_files() {
    local shell="$1"
    if [ "$shell" = "zsh" ]; then
        echo "$BASH_FILES"
    else
        echo "$ZSH_FILES"
    fi
}

get_all_dotfiles() {
    echo "$SHARED_FILES $BASH_FILES $ZSH_FILES"
}

backup_file() {
    local file="$1"
    local target="$HOME/$file"

    if [ -e "$target" ] && [ ! -L "$target" ]; then
        cp "$target" "$BACKUP_DIR/$file"
        echo "  backed up $file"
    fi
}

create_symlink() {
    local file="$1"
    local source="$DOTFILES_DIR/$file"
    local target="$HOME/$file"

    if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
        echo "  already linked  $file"
        return
    fi

    if [ -L "$target" ]; then
        rm "$target"
    elif [ -e "$target" ]; then
        rm "$target"
    fi

    ln -s "$source" "$target"
    echo "  linked  $file"
}

remove_symlink() {
    local file="$1"
    local source="$DOTFILES_DIR/$file"
    local target="$HOME/$file"

    if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
        rm "$target"
        echo "  removed symlink  $file"
    fi
}

# --- Menu actions ---

do_install() {
    echo ""
    echo "Select your shell:"
    echo "  1) Zsh"
    echo "  2) Bash"
    echo ""
    printf "Choose [1-2]: "
    read -r shell_input

    local shell_choice
    case "$shell_input" in
        1) shell_choice="zsh" ;;
        2) shell_choice="bash" ;;
        *)
            echo "Invalid choice."
            return
            ;;
    esac

    echo ""
    echo "Setting up for $shell_choice..."
    echo ""

    # First run: create backup of all original dotfiles
    if [ ! -d "$BACKUP_DIR" ]; then
        echo "First run - backing up original dotfiles..."
        mkdir -p "$BACKUP_DIR"
        for file in $(get_all_dotfiles); do
            backup_file "$file"
        done
        print_separator
        echo ""
    fi

    # If shell choice changed, remove old shell symlinks
    if [ -f "$SHELL_CHOICE_FILE" ]; then
        local previous_shell
        previous_shell="$(cat "$SHELL_CHOICE_FILE")"
        if [ "$previous_shell" != "$shell_choice" ]; then
            echo "Switching from $previous_shell to $shell_choice..."
            for file in $(get_other_shell_files "$shell_choice"); do
                remove_symlink "$file"
            done
            echo ""
        fi
    fi

    # Create symlinks for shared files
    echo "Linking shared dotfiles..."
    for file in $SHARED_FILES; do
        create_symlink "$file"
    done
    echo ""

    # Create symlinks for chosen shell
    echo "Linking $shell_choice dotfiles..."
    for file in $(get_shell_files "$shell_choice"); do
        create_symlink "$file"
    done

    # Save shell choice
    echo "$shell_choice" > "$SHELL_CHOICE_FILE"

    # Source new config
    echo ""
    printf "Source the new shell config now? [y/N]: "
    read -r source_input

    if [ "$source_input" = "y" ] || [ "$source_input" = "Y" ]; then
        if [ "$shell_choice" = "zsh" ]; then
            echo "  sourcing ~/.zprofile..."
            source "$HOME/.zprofile" 2>/dev/null
        else
            echo "  sourcing ~/.bash_profile..."
            source "$HOME/.bash_profile" 2>/dev/null
        fi
        echo "  done."
    else
        echo "  Open a new terminal to apply changes."
    fi

    # Summary
    echo ""
    print_separator
    echo ""
    echo "Remember to configure your git identity:"
    echo "  git config --global user.name \"Your Name\""
    echo "  git config --global user.email \"your@email.com\""
    echo ""
}

do_status() {
    echo ""
    echo "Dotfile status:"
    echo ""

    local shell_choice=""
    if [ -f "$SHELL_CHOICE_FILE" ]; then
        shell_choice="$(cat "$SHELL_CHOICE_FILE")"
        echo "  Shell: $shell_choice"
        echo ""
    fi

    local active_files="$SHARED_FILES"
    if [ -n "$shell_choice" ]; then
        active_files="$active_files $(get_shell_files "$shell_choice")"
    else
        active_files="$active_files $BASH_FILES $ZSH_FILES"
    fi

    for file in $active_files; do
        local target="$HOME/$file"
        local source="$DOTFILES_DIR/$file"

        if [ -L "$target" ]; then
            local link_target
            link_target="$(readlink "$target")"
            if [ "$link_target" = "$source" ]; then
                printf "  %-20s linked\n" "$file"
            else
                printf "  %-20s linked (other: %s)\n" "$file" "$link_target"
            fi
        elif [ -e "$target" ]; then
            printf "  %-20s exists (not linked)\n" "$file"
        else
            printf "  %-20s missing\n" "$file"
        fi
    done

    echo ""
    if [ -d "$BACKUP_DIR" ]; then
        echo "  Backup: $BACKUP_DIR (exists)"
    else
        echo "  Backup: none"
    fi
    echo ""
}

do_rollback() {
    if [ ! -d "$BACKUP_DIR" ]; then
        echo ""
        echo "No backup found. Nothing to rollback."
        echo ""
        return
    fi

    echo ""
    echo "This will remove all dotfile symlinks and restore"
    echo "your original files from $BACKUP_DIR"
    echo ""
    printf "Continue? [y/N]: "
    read -r confirm

    if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
        echo "  Aborted."
        return
    fi

    echo ""
    echo "Removing symlinks..."
    for file in $(get_all_dotfiles); do
        remove_symlink "$file"
    done

    echo ""
    echo "Restoring originals..."
    for file in $(get_all_dotfiles); do
        if [ -f "$BACKUP_DIR/$file" ]; then
            cp "$BACKUP_DIR/$file" "$HOME/$file"
            echo "  restored  $file"
        fi
    done

    rm -rf "$BACKUP_DIR"
    echo ""
    echo "Rollback complete. Original dotfiles restored."
    echo "Backup directory removed."
    echo ""
}

# --- Main ---

# Root guard
if [ "$(id -u)" -eq 0 ]; then
    echo "Error: Do not run this script as root or with sudo."
    echo "Run it as your normal user: ./install.sh"
    exit 1
fi

print_header

echo "  1) Install   - Back up existing dotfiles and create symlinks"
echo "  2) Status    - Show current state of all symlinks"
echo "  3) Rollback  - Restore original dotfiles from backup"
echo "  4) Quit"
echo ""
printf "Choose [1-4]: "
read -r choice

case "$choice" in
    1) do_install ;;
    2) do_status ;;
    3) do_rollback ;;
    4) echo ""; echo "Bye."; echo "" ;;
    *) echo ""; echo "Invalid choice." ;;
esac
