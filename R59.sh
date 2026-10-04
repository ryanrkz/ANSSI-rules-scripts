#!/bin/bash
#R59 says only trusted repositories should be used
#This script searches the package repository URLs configured on the system
#and lists the ones that are not part of the official Ubuntu repositories
TRUSTED="archive.ubuntu.com|security.ubuntu.com|ports.ubuntu.com" #List of trusted Ubuntu repository
FILES="/etc/apt/sources.list /etc/apt/sources.list.d/*" #APT repository configuration files
#These files contain the list of package repositories used by the system to download and update software

RESULT=$(grep -hs "URIs:" $FILES 2>/dev/null | grep -v '^#' | grep -Ev "$TRUSTED")
#We search for repository URLs using the "URIs:" lines found in .sources files
#-h hides filenames in the output
#-s hides error messages if some files cannot be read
#2>/dev/null hides error messages
#grep -v '^#' removes commented lines
#grep -Ev "$TRUSTED" keeps only lines that do not contain a trusted domain
if [ -z "$RESULT" ]; then #If RESULT is empty, no untrusted repository was found
    echo "OK only trusted repositories detected" #Then we consider R59 respected
else #If RESULT is not empty, some repositories do not look trusted
    echo "$RESULT" | while read -r line; do  #Read each untrusted repository line
        #read -r prevents backslashes from being interpreted
        echo "KO untrusted repository: $line" #Print the repository line that needs review
    done
fi
