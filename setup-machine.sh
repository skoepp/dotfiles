# copy paste this file in bit by bit.
# don't run it.
  echo "do not run this script in one go. hit ctrl-c NOW"
  read -n 1


##############################################################################################################
###  backup old machine's key items

mkdir -p ~/migration/home

cp ~/.bashrc ~/migration/home
cp ~/.bash_profile ~/migration/home

cp ~/.extra ~/migration/home
cp ~/.z ~/migration/home

cp ~/.gitconfig ~/migration/home

###
##############################################################################################################

##############################################################################################################
### install of common things
###

# github.com/rupa/z
git clone https://github.com/rupa/z.git ~/code/z
# z is hooked up in .bash_profile

# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# Homebrew is used in .aliases

# Homebrew packages
brew install coreutils node
# coreutils, node and npm are used in .aliases

# Global npm packages
npm -g install npm-check
# npm-check is used in .aliases

###
##############################################################################################################
