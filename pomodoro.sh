#!/bin/sh

# A simple pomodoro timer. Uses an interval of 25 minutes on, 5 minutes off by
# default, but is configurable using optional arguments.
#
# Usage:
#     ./pomodoro.sh [on time] [off time]
#
# Example (using an interval of 30 min on, 10 min off):
#     ./pomodoro.sh 30 10

set -eu

ON_TIME=25
OFF_TIME=5

DEPENDENCIES='beep date printf sleep'

COLOR_RED='\033[1;31m'
COLOR_END='\033[0m'


# Check that an executable is installed and accessable.
# $1 -- name of executable
check_executable() {
    which "$1" >/dev/null 2>&1 || return 1
}


# Countdown a given period of time, printing the time left to stdout.
# $1 -- time in seconds
countdown() {
    end_date=$(($(date +%s) + $1));
    while [ "$end_date" -ge "$(date +%s)" ]; do
        printf "\r%s" "$(date -u --date @$((end_date - $(date +%s))) +%H:%M:%S)"
        sleep 0.1
    done
}


# $1 -- on time in minutes (optional, 25 minutes by default)
# $2 -- off time in minutes (optional, 5 minutes by default)
main() {
    for dependency in $DEPENDENCIES; do
        check_executable "$dependency" || {
            printf "${COLOR_RED}Missing '%s'\n${COLOR_END}" "$dependency" 1>&2
            return 1
        }
    done

    if [ "$#" -ge 1 ]; then
        ON_TIME="$1"
    fi
    if [ "$#" -ge 2 ]; then
        OFF_TIME="$2"
    fi

    while true; do
        notify-send "$0" "On for $ON_TIME minutes."
        countdown $(("$ON_TIME" * 60))
        notify-send "$0" "Taking a $OFF_TIME minute break."
        countdown $(("$OFF_TIME" * 60))
    done
}


main "$@"
