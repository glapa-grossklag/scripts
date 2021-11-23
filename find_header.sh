#!/bin/sh
# A script to find the location of C header files.
#
# Example:
#     $ ./find_header.sh stdbool.h stdio.h
#     /usr/lib/gcc/x86_64-pc-linux-gnu/11.1.0/include/stdbool.h
#     /usr/include/stdio.h
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
