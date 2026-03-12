# copy paste this file in bit by bit.
# don't run it.
  echo "do not run this script in one go. hit ctrl-c NOW"
  read -n 1


##############################################################################################################
### install of common things
###

# github.com/rupa/z
git clone https://github.com/rupa/z.git ~/code/z
# z is hooked up in .bash_profile

# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Homebrew packages (install from Brewfile in this repo)
brew bundle

# Global npm packages
npm -g install npm-check
# npm-check is used in .aliases

###
##############################################################################################################
