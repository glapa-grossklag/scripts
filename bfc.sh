#!/usr/bin/env bash
# A script to go from Brainfuck to C to an executable.
set -eu

PRELUDE=$(cat << EOF
#include <stdio.h>

int main(void) {
    char array[65536] = {0};
    char *ptr = array;
EOF
)

POSTLUDE=$(cat << EOF
}
EOF
)

# Translates Brainfuck to C.
#
# Parameters:
#     $1 : Brainfuck source code.
translate() {
	bf_src="$1"

	for (( i=0; i<${#bf_src}; i+=1 )); do
		symbol="${bf_src:$i:1}"

		case "$symbol" in
			'>')
				echo '++ptr;'
				;;
			'<')
				echo '--ptr;'
				;;
			'+')
				echo '++*ptr;'
				;;
			'-')
				echo '--*ptr;'
				;;
			'.')
				echo 'putchar(*ptr);'
				;;
			',')
				echo '*ptr = getchar();'
				;;
			'[')
				echo 'while (*ptr) {'
				;;
			']')
				echo '}'
				;;
		esac
	done
}

# Compile C source code to an executable.
#
# Parameters:
#     $1 : C source code.
#     $2 : The name of the executable to create.
compile() {
	c_src="$1"
	target="$2"

	# Create a temporary file, and mark it for deletion on exit.
	c_src_file=$(mktemp --suffix='.c')
	trap 'rm -f "$c_src_file"' EXIT

	echo "$c_src" > "$c_src_file"

	cc -o "$target" "$c_src_file"
}

main() {
	bf_src_file="$1"

	bf_src=$(cat "$bf_src_file")
	c_src=$(translate "$bf_src")
	c_src="${PRELUDE}${c_src}${POSTLUDE}"
	# echo "$c_src"
	compile "$c_src" "${bf_src_file%.bf}"
}

main "$@"
