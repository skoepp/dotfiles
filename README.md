## DOTFILES
Everything starts with configuring your development environment.

Dot files play a role when setting up your macOS system. This repository contains shell configurations, aliases, git settings, and an interactive installer to get everything in place.

### Setup

#### 1. Clone the repository

```bash
git clone git@github.com:skoepp/dotfiles.git
cd dotfiles
```

#### 2. Install Homebrew
Follow the install command in `setup-machine.sh` or see [brew.sh](https://brew.sh):

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### 3. Install dotfiles
Run the interactive installer to back up your existing dotfiles and create symlinks:

```bash
./install.sh
```

The installer will:
- Ask you to choose between Zsh or Bash
- Ask for your platform (Apple Silicon or Intel)
- Back up your original dotfiles on first run
- Generate `~/.homebrew_env` with the correct Homebrew path for your platform
- Create symlinks to your home directory
- Optionally source the new config in your current shell

#### 4. Install packages
Install all Homebrew packages from the Brewfile:

```bash
brew bundle
```

See `setup-machine.sh` for additional tools (z, npm-check) that can be installed manually.

#### 5. Configure Git
Add your Git identity:

```bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

### Managing dotfiles
Run `./install.sh` again at any time to:
- **Install** — update or repair symlinks, switch shell or platform
- **Status** — check which dotfiles are linked and your current configuration
- **Rollback** — restore your original dotfiles from backup

### License
Code released under an MIT license.
Fork away, do whatever. Pull requests welcome.
