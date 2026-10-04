#!/bin/bash
#This script checks ANSSI rule R42
#R42 requires that sudo command specifications must not use negation
#In sudoers, negation is written with the character '!' and is used to exclude commands from a rule
#The goal is to avoid ambiguous sudo rules that could misinterpreted

#We will not go too much in details in the comments
#because R42 script is similar to R40 except except that it searches for sudo rules containing negation ('!') instead of focusing on rules targeting root (#).
RESULT=$(grep -hEv '^\s#|^\s$'  /etc/sudoers /etc/sudoers.d/* 2>/dev/null \
| grep -E '(root)' \
| grep -Ev '^root[[:space:]]'\
| grep  '!') #'\' used to continue the line

if [ -z "$RESULT" ]; then
    echo "OK"
else
    echo "$RESULT" | while read -r line; do
        user=$(echo "$line" | awk '{print $1}')
        target=$(echo "$line" | awk '{print $3}')
        cmd=$(echo "$line" | awk '{print $NF}')
        echo "KO $user ${target//[()]/} on $cmd"
    done
fi
