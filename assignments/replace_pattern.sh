#!/bin/bash
# Jordan Strickland
# Script: replace_pattern.sh
# Description: Replaces all instances of a pattern with the replacement text.

pattern="$1"
replacement="$2"

sed "s/$pattern/$replacement/g"
