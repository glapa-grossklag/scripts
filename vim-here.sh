#!/bin/bash

FILE=$(mktemp)
$EDITOR "${FILE}"
xclip -selection c < "${FILE}"
