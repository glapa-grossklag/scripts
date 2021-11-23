#!/usr/bin/env python3
"""
This is basically grep, but with the bonus of having access to Python's stdlib.

This example grabs all lines that looks like a number and computes their average.
"""

import re
import sys

# Match any line that contains only digits.
pattern = r"^\d+$"
expression = re.compile(pattern, re.IGNORECASE)


def main() -> None:
    numbers = []

    for line in sys.stdin:
        match = expression.match(line)
        if match:
            numbers.append(int(line))

    print(sum(numbers) / len(numbers))


if __name__ == "__main__":
    main()
