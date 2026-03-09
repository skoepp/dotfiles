## dot files
Everything starts with configuring your development environment.

So dot files play a role when setting up your MAC or Linux system. As many before I'm creating my own dot files repository by analysing and adapting good solutions that already exists. My main reference is the dot files repository from [Paul Irish](https://github.com/paulirish).

### Setup

#### 1. Install tools
Use the command collection in `setup-machine.sh` to prepare the system. Read the file before executing — it is meant to be run step by step, not all at once.

```bash
# Install Homebrew packages
brew bundle
```

#### 2. Install dotfiles
Run the interactive installer to back up your existing dotfiles and create symlinks:

```bash
./install.sh
```

The installer will:
- Ask you to choose between Zsh or Bash
- Back up your original dotfiles on first run
- Create symlinks to your home directory
- Optionally source the new config in your current shell

#### 3. Configure Git
Add your Git identity:

```bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

#### Managing dotfiles
Run `./install.sh` again at any time to:
- **Status** — check which dotfiles are linked
- **Rollback** — restore your original dotfiles from backup

### License
Code released under an MIT license.
Fork away, do whatever. Pull requests welcome.
