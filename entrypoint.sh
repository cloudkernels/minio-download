#!/bin/bash

LOG_NAME="minio"

info() {
    [ -t 1 ] && [ -n "$TERM" ] \
        && echo "$(tput setaf 2)[$LOG_NAME]$(tput sgr0) $*" \
        || echo "[$LOG_NAME] $*"
}

err() {
	[ -t 2 ] && [ -n "$TERM" ] \
		&& echo -e "$(tput setaf 1)[$LOG_NAME]$(tput sgr0) $*" 1>&2 \
		|| echo -e "[$LOG_NAME] $*" 1>&2
}

die() {
	err "$@"
	exit 1
}

ok_or_die() {
	if [ $? -ne 0 ]; then
		die $1
	fi
}

if [[ $# -ne 4 ]] ; then
	die "Insufficient number of arguments"
fi

url=$1
access_key=$2
secret_key=$3
local_path=$4
remote_path=$5

echo "mc alias set s3 $url $access_key $secret_key"
ok_or_die "Could not set mc alias"

echo "mc cp -r s3/$remote_path $local_path"
ok_or_die "Could not fetch object"
