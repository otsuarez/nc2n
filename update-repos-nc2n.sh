#!/bin/bash

# list of urls for nagios configuration repositories
CFG_FILE="config/repositories"
# where are the nagios configuration repos live (parent dir by default)
REPOS_DIR="workspace/"
# clone nagios configuration repo if not exists
UPDATEREPO="yes"

warm() { echo "$@" 1>&2 ; }
die() { echo "$@" 1>&2 ; exit 1; }

update_repo() {
	#warm "missing repository directory: $1"
	#die "repository directory: $1"
	if [ ${UPDATEREPO} == "yes" ]; then
		pushd ${REPOS_DIR}/$1 > /dev/null 2>&1
		echo "updating $1"
		git pull || die "error with git pull $1"
		git add --all .
		git commit -am"update nc2n"
		git push
		popd
	fi
}

update_repos() {

	while read p; do
		REPO=":$(echo $p | sed 's|.*/\(.*\)\.git$|\1|')"
		TMP_REPOS="${TMP_REPOS}${REPO}"
	done <config/repositories

	REPOS=$(echo ${TMP_REPOS} | sed 's/^://')

	for i in $(echo ${REPOS} | tr ":" "\n")
	do
		#[ -d "${DATA_DIR}/${i}" ] || create_repo_datadir "${i}"
		update_repo "${i}"
	done

}

update_repos


# vim: set tabstop=2 shiftwidth=2 sts=2 autoindent smartindent:
