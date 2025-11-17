#!/bin/bash
# Jordan Strickland
# Script: replace_pattern_awk.sh
# Description: Replaces all instances of a pattern using awk.

pattern="$1"
replacement="$2"

awk "{ gsub(/$pattern/, \"$replacement\"); print }"
