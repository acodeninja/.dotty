#!/bin/sh

# get last command return value
function nonzero_return() {
	RETVAL=$?
	[ $RETVAL -ne 0 ] && echo " [$RETVAL]"
}

# get the current git repo author email
function get_git_author() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		echo " [$(git config user.email)]"
	else
		echo ""
	fi
}

# get current branch in git repo
function get_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`get_git_dirty`
		echo " [${BRANCH}${STAT}]"
	else
		echo ""
	fi
}

# get current status of git repo
function get_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

# Get count of background processes
function get_background_job_count {
	STOPPED_FILE=/tmp/$$-stopped
	RUNNING_FILE=/tmp/$$-running
	echo 0 > $STOPPED_FILE
	echo 0 > $RUNNING_FILE

	jobs | while read line ; do
		if [[ $line =~ "Stopped" ]]; then
			STOPPED=$(($(cat $STOPPED_FILE) + 1))
			echo $STOPPED > $STOPPED_FILE;
		fi
		if [[ $line =~ "Running" ]]; then
			RUNNING=$(($(cat $RUNNING_FILE) + 1))
			echo $RUNNING > $RUNNING_FILE;
		fi
	done

	STOPPED=$(cat $STOPPED_FILE)
	RUNNING=$(cat $RUNNING_FILE)

	if [ "$STOPPED" != "0" ] || [ "$RUNNING" != "0" ]; then
		echo " [$RUNNING running $STOPPED stopped]";
 	fi
}

function get_load_average {
	echo " [load: $(cat /proc/loadavg)]"
}

function get_current_versions {
	BITS=""

	if [ "$(which php)" != "" ]; then
		if [ "$BITS" != "" ]; then
			BITS="$BITS ";
		fi
		BITS="${BITS}php: v$(echo "<?php \$matches = []; preg_match('/([0-9\.]+)/', PHP_VERSION, \$matches); echo \$matches[0];" | php)"
	fi

	if [ "$(which node)" != "" ]; then
		if [ "$BITS" != "" ]; then
			BITS="$BITS ";
		fi
		BITS="${BITS}node: $(node -v)"
	fi

	if [ "$BITS" != "" ]; then
		echo " [$BITS]"
	fi
}
