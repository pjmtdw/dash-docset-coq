#!/bin/bash

OP="$2"

# replace 8.9+beta1 -> 8.9~beta1
VER1="${1/+/\~}"
VER2="${3/+/\~}"

dpkg --compare-versions "$VER1" "$OP" "$VER2"
