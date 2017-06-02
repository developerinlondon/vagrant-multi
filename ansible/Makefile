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
.PHONY: galaxy vagrant

galaxy: ## run ansible galaxy to prepare
	ansible-playbook -vv install_roles.yml -i 'localhost,' -c local

virtualbox: ## run ansible-playbook on vagrant
	ansible-playbook -vv -i inventory/virtualbox/manager.ini playbook.yml
