.PHONY: main run
all: help
main: nagios01

help:
	@echo "make run reponame=<repository_name>"
	@echo "For example:"
	@echo "make run reponame=nagios01-conf"

nagios01:
	ansible-playbook main.yml -e reponame=nagios01-conf -l nagios01-conf

run:
	ansible-playbook main.yml -e reponame=$(reponame) -l $(reponame)

init: 
	./init-nc2n.sh

update: 
	./update-repos-nc2n.sh

ping:
	ansible -m ping -i inventory all -o
love:
	@echo "not war"
