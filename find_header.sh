#!/bin/sh
set -eu

find_header() {
	echo "#include <${1}>" | cpp -H -o /dev/null 2>&1 | head -n 1 |cut -f 2 -d ' '
}

main() {
	for header in "$@"; do
		find_header "$header"
	done
}

main "$@"
