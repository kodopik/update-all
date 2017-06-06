#!/usr/bin/env bash
#
# update-all
# v.1.3
# (c) Anton 'KodopiK' Konoplev, 2017
# kodopik@kodopik.ru
#
# What this script actually does:
#
# apt update \
#     && apt list --upgradable \
#     && apt dist-upgrade [-y] \
#     && apt autoremove [-y] \
#     && apt autoclean

set -eo pipefail

source /etc/lsb-release || ( \
    echo 'Cannot import LSB variables' >&2
    exit 1
)

if [[ $DISTRIB_ID != 'Ubuntu' ]]; then
    echo 'Sorry, Ubuntu only' >&2
    exit 1
fi

declare -ri UBUNTU_RELEASE=${DISTRIB_RELEASE%%.*}
apt_command='apt'
if [[ $UBUNTU_RELEASE -lt 16 ]]; then
    apt_command='apt-get'
fi

PARAMS='-y'
declare -r APP_NAME=`basename $0`
declare -r USAGE_MESS="Usage: $APP_NAME [OPTIONS]"
declare -r ERR_MESS=`cat << EOF
${USAGE_MESS}

${APP_NAME}: error: no such option: ${1}
EOF
`

function print_help {
    echo $USAGE_MESS
    cat << EOF

Options:
    -i          Run interactively (ask for upgrade and remove)
    -h, --help  Print this message
EOF
}

if [[ -n "$1" ]]; then
    case "$1" in
        -i) PARAMS='';;
        -h|--help) print_help
            exit 0;;
        *) echo "$ERR_MESS" >&2
            exit 1;;
    esac
fi

if [[ $UID != 0 ]]; then
    printf "Please run this script with sudo:\nsudo %s %s\n" "$APP_NAME" "$*" >&2
    exit 1
fi

function print_message {
    MESSAGE="$1"
    printf '\n**** %s: ****\n\n' "${MESSAGE}"
}

function update {
    print_message 'UPDATING'
    $apt_command update
}

function list {
    print_message 'UPGRADABLE SOFTWARE'
    $apt_command list --upgradable
}

function upgrade {
    print_message 'UPGRADING'
    $apt_command dist-upgrade $PARAMS
}

function remove {
    print_message 'REMOVING OBSOLETE SOFTWARE:'
    $apt_command autoremove $PARAMS
}

function clean {
    print_message 'CLEANING SYSTEM:'
    $apt_command autoclean
}

function main {
    update  && \
    list    && \
    upgrade && \
    remove  && \
    clean
}

main

exit 0
