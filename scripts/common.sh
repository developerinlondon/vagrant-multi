#!/usr/bin/env bash

setup_repo() {
  curl -s https://gerrit.googlesource.com/git-repo/+/stable/repo?format=TEXT | base64 -D > /usr/local/bin/repo
  chmod +x /usr/local/bin/repo
}

setup_gpg() {
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
}

setup_rvm() {
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
}

setup_tools() {
  setup_gpg
  setup_rvm
  brew install bash-completion
  brew install git-crypt
  brew install pre-commit
  brew install shellcheck
  git-crypt unlock

  # install ruby libraries and salt-lint
  gem install bundler
  bundle install
}
