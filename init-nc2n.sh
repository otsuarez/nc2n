#!/bin/bash

# list of urls for nagios configuration repositories
CFG_FILE="config/repositories"
# where are the nagios configuration repos live (parent dir by default)
REPOS_DIR="workspace/"
# clone nagios configuration repo if not exists
BOOTSTRAP="yes"
DATA_DIR="data"

warm() { echo "$@" 1>&2 ; }
die() { echo "$@" 1>&2 ; exit 1; }

missing_repo() {
	warm "missing repository directory: $1"
	if [ $BOOTSTRAP == "yes" ]; then
		pwd
		repo_url=$(grep $1 $CFG_FILE)
		pushd ${REPOS_DIR} > /dev/null 2>&1 || die "error with repositories dir: ${REPOS_DIR}"
		echo "cloning $repo_url"
		git clone $repo_url
		popd
	fi
}

create_repo_datadir() {
	ansible-playbook init ${DATA_DIR}/$1
}


init-check() {

	[ -d "${REPOS_DIR}" ] || mkdir "${REPOS_DIR}"

	while read p; do
		REPO=":$(echo $p | sed 's|.*/\(.*\)\.git$|\1|')"
		TMP_REPOS="${TMP_REPOS}${REPO}"
	done <config/repositories

	REPOS=$(echo ${TMP_REPOS} | sed 's/^://')

	for i in $(echo ${REPOS} | tr ":" "\n")
	do
		[ -d "${REPOS_DIR}/${i}" ] || missing_repo "${i}"
		[ -d "${DATA_DIR}/${i}" ] || create_repo_datadir "${i}"
	done

	ansible  --version > /dev/null 2>&1 || die "Please install ansible"
}

#init-check
[ -d "$REPOS_DIR" ] || init-check


# vim: set tabstop=2 shiftwidth=2 sts=2 autoindent smartindent:
