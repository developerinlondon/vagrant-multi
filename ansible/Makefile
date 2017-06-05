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
.PHONY: prepare galaxy virtualbox scaleway

prepare:  ## prepares scripts, run ansible-playbook -vv prepare.yml -i 'inventory/localhost' -c local
	ansible-playbook -vv prepare.yml -i 'inventory/localhost' -c local

virtualbox: ## run ansible-playbook -vv -i inventory/virtualbox/manager.ini playbook.yml
	ansible-playbook -vv -i inventory/virtualbox/manager.ini playbook.yml

scaleway: ## run ansible-playbook -vv -i inventory/scaleway/manager.ini playbook.yml
	ansible-playbook -vv -i inventory/scaleway/manager.ini playbook.yml
