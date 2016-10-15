# Description 

This tool simplifies the maintenance of nagios configuration files. The goal is to allow a non-technical user to edit hosts in a csv file, then, use this tool create the corresponding nagios configuration files. Ansible being the glue in this scenario.

# tl;dr

```
# 1. Add the nagios configuration repository url to the <code>config/repositories</code> file. One line per repo.
vi config/repositories

# 2. Bootstrap the directory structure.
./init-nc2n.sh

# 3. Run the playbook. Use the name of the repository as the variable reponame.
REPO=nagios01-conf
ansible-playbook main.yml -e reponame=$REPO
```

# Directory Hierarchy

```
.
|-- ansible.cfg
|-- config
|   `-- repositories
|-- data
|   `-- nagios01-conf
|       |-- files
|       |   `-- csv
|       |       `-- ap.csv
|       |-- tasks
|       |   `-- main.yml
|       |-- templates
|       |   |-- ap.cfg.j2
|       |   `-- virtual_ap.cfg.j2
|       `-- vars
|           `-- main.yml
|-- init-nc2n.sh
|-- inventory
|   `-- inventory.sh
|-- lookup_plugins
|   |-- csvrecord.py
|   `-- csvrecord.pyc
|-- main.yml
|-- Makefile
|-- README.md
`-- workspace
```


# Requirements

ansible

```
pip install ansible
```

# Configuration

The file <code>config/repositories</code> contains a list of git repositories. Each of those repositories are pulled into the <code>workspace</code> directory where the resulting configuration files wil be stored. 

> You should be storing your nagios' etc directory in git. Do you?

# Data Directory

Each of the subdirectories under the <code>data</code> directory will store everything that's needed for creating the nagios configuration files.

The <code>files</code> folder is the source of data. In the example, a <code>csv</code> subfolder contains the ... well, csv files.

The <code>templates</code> folder will have the templates, which are using the jinja2 format.

An ansible user will already had noted certain familiarity. Indeed, each subfolder under <code>data</code> folder it's an ansible's role. 

It's common for each nagios server to have it's own set of requirements for the configuration files. Those requirements are encapsulated in the <code>tasks/main.yml</code> file.

The <code>vars/main.yaml</code> file have definitions for the task file.

This way, the data directory can even be split in multiple repositories, so differents teams can work only with their data.


# Continuous Delivery

The pipeline is composed by two elements:

* The source code git repository.
* A jenkins job.

Configure the jenkins job to be triggered when a commit is made on the repository. Add a build step, selecting Execute shell with the following content:

```
REPO=nagios01-conf
./init-nc2n.sh
ansible-playbook main.yml -e reponame=${REPO} -l ${REPO}
./update-repos-nc2n.sh
```

# Testing

Before deploying the configuration files to a server, a check is usually performed. A docker image is available for those not having nagios installed on the host where this scripts are being executed.

An example usage for the current repository:

```
docker run --name preflight   -v `pwd`/workspace/nagios01-conf:/opt/nagios/etc toja/nagios-check:latest
```

# Lookup plugin

The ansible lookup plugin was written for this project since the existing one didn't had the required funcionality. For the template to work, a way of iterating over an csv file was required, which what the lookup plugin does.

# ansible tips

To get the role directory:

```
role_dir: "{{ lookup('pipe', 'pwd') | dirname }}"
```

To get the role name:

```
role_name: "{{ lookup('pipe', 'pwd') | dirname | basename }}"
```

# Notes

Tested with ansible 2.1.2.0
