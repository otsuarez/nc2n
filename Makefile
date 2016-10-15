.PHONY: main
all: help

nagios01:
	ansible-playbook main.yml -e reponame=nagios01-conf -l nagios01-conf

help:
	@echo "make run reponame=<repository_name>"
	@echo "For example:"
	@echo "make run reponame=nagios01-conf"

main:
	ansible-playbook --list-tasks main.yml

run:
	ansible-playbook --list-tasks main.yml -e reponame=$(repo)

ping:
	ansible -m ping -i inventory all -o
love:
	@echo "not war"
