#!/usr/bin/env bash
set -eu
printf "$(tput setaf 5)==> Preparing Workstation for Vagrant$(tput sgr0)\n"
if ! [ -x "$(command -v gpg)" ]; then
  if [[ "$OSTYPE" == "darwin"* ]]; then
    printf "$(tput setaf 5)==> Installing 'gpg'$(tput sgr0)\n"
    brew install gnupg2
    brew link --overwrite gnupg
  else
    printf "$(tput setaf 1)==> 'gpg' not found! Please install 'gpg' and try again. Exiting.$(tput sgr0)\n"
    exit
  fi
  gpg --keyserver hkp://pgp.mit.edu --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
else
  printf "$(tput setaf 2)==> 'gpg' already installed!$(tput sgr0)\n"
fi

if ! [ -x "$(command -v rvm)" ]; then
  unset GEM_HOME
  printf "$(tput setaf 5)==> Installing 'rvm'$(tput sgr0)\n"
  \curl -sSL https://get.rvm.io | bash
  echo rvm_auto_reload_flag=1 > ~/.rvmrc
  printf "$(tput setaf 5)==> Installing Ruby 2.4.0$(tput sgr0)\n"
  ~/.rvm/bin/rvm install 2.4.0
  printf "$(tput setaf 5)==> Making sure Gems are uptodate$(tput sgr0)\n"
  gem install bundler
  bundle
else
  printf "$(tput setaf 2)==> 'rvm' already installed!$(tput sgr0)\n"
fi
printf "$(tput setaf 5)==> Workstation Preparation Complete.$(tput sgr0)\n"

brew install bash-completion
brew install git-crypt
brew install pre-commit
brew install shellcheck
git-crypt unlock

# install ruby libraries and salt-lint
gem install bundler
bundle install
