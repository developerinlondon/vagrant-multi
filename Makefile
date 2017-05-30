#
# Why use Makefile?
# because you get help lists & auto-complete on complex commands
#
SHELL := /bin/bash
help:           ## Show this help.
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

#
# linebreak
#
: ## ======================================================================

#
# make all output silent - ie: no CMDs shown
#.SILENT:

# include ../parentMakefile

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
 # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


#
# Variables
#

#
# Init Related
#
.PHONY: init

init: ## Prepare the environment for vagrant
	source ./scripts/common.sh && setup_repo

repo_install: ## install repo
	source ./scripts/common.sh && setup_repo

repo_init: ## initialize repo
	repo init \
    --repo-url git@github.com:developerinlondon/android_repo.git \
    -u git@github.com:developerinlondon/vagrant-multi-maifest.git \
	-b master

gpg-recrypt:
	./scripts/re-crypt.sh
