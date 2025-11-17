#!/bin/bash
# Jordan Strickland
# Script: search_pattern.sh
# Description: Prints all input lines containing the literal pattern provided.

pattern="$1"   # first command-line argument is the pattern to search for

grep "$pattern"
