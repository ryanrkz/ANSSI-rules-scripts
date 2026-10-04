#!/bin/bash
#This script tries to check ANSSI R40 (we are not 100% sure it does what is intended).
#R40 recommends avoiding sudo rules that run commands as root whenever possible, and using non privileged target users instead
#The goal is to reduce the risk of privilege escalation and limit the impact of commands executed through sudo

RESULT=$(grep -hEv '^\s#|^\s$'  /etc/sudoers /etc/sudoers.d/* 2>/dev/null\
| grep -E '(root)'\
| grep -Ev '^root[[:space:]]'\
| grep -v '#') #'\' used to continue the line
# grep -Ev line removes lines starting with "root " (root followed by space)

#RESULT stores every sudo rule line that seems to target the root user
#we search in both /etc/sudoers and in every file inside /etc/sudoers.d/, because sudo rules can be defined in one or the other
#grep -h disables printing filenames, so only matching lines are returned
#grep -E enables extended regular expressions, which makes patterns easier to write
#grep -v inverts the match, meaning it keeps lines that do not match the given pattern
#The pattern '^\s#|^\s$' is used to remove commented lines and empty lines, so only real sudo rules remain
#2>/dev/null hides error messages*
#The second grep keeps only lines containing the string "root", because sudo rules often specify the target user like "(root)"
#The third grep removes lines starting with "root " because those are rules written for the root account itself, not rules granting root access to other users
#The last grep removes any remaining line containing '#', to avoid comments

if [ -z "$RESULT" ]; then #If RESULT is empty, no  sudo rule was detected by the filters
    echo "OK" #Then we consider that R40 is respected
else #If RESULT contains one or more lines, some sudo rules appear to target root
    echo "$RESULT" | while read -r line; do  #Read each matching sudo rule line without interpreting '\' (option -r)
    
        user=$(echo "$line" | awk '{print $1}') #Extract the first field (the user allowed to run sudo)
        target=$(echo "$line" | awk '{print $3}') #Extract the third field (the target, like root)
        cmd=$(echo "$line" | awk '{print $NF}') #Extract the last field (the command allowed)
        echo "KO $user ${target//[()]/} on $cmd" #Print a message showing who can run what as which target user
        #${target//[()]/} removes '(' and ')' so "(root)" becomes "root" in the output
    done
fi
