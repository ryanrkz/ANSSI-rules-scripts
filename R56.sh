#!/bin/bash
#This script checks ANSSI R56
#R56 says we should avoid setuid and setgid executables
#Only trusted software should keep these special permissions
#Trusted software usually means software coming from the distribution or official repositories
#This script lists setuid/setgid files and tries to see if they come from a known package and a trusted repository

#We search for regular files with setuid or setgid bits
#-xdev avoids searching inside other mounted filesystems(without it it runs forever)
#-perm /6000 (given in the rule) is an octal mask for special permissions 4000(setuid)+2000(setgid)
#2>/dev/null hides permission errors during the scan
find / -xdev -type f -perm /6000 2>/dev/null | while read -r file; do #reads each line of the input and stores it in the variable file
    #For each file we try to find which package owns it
    #dpkg -S prints the package name if the file is managed by dpkg (package manager)
    dpkg_result=$(dpkg -S "$file" 2>/dev/null)

    if [ -n "$dpkg_result" ]; then
        #If dpkg_result is not empty the file belongs to a package
        #dpkg -S output looks like "package: path"
        #We extract the package name before the first ':'
        pkg=$(echo "$dpkg_result" | head -n1 | cut -d: -f1)

        #We check where the package comes from using apt-cache policy
        policy=$(apt-cache policy "$pkg" 2>/dev/null)

        #If the policy contains official Ubuntu domains we consider it trusted
        if echo "$policy" | grep -Eq '(security\.ubuntu\.com/ubuntu|archive\.ubuntu\.com/ubuntu|ports\.ubuntu\.com/ubuntu)'; then # '|' means "or", '\' is used to espace for '.'
            echo "OK $file (setuid/setgid, package: $pkg, official Ubuntu repository)"
        else
            #If the package origin is not clearly official we put a warning (case by case)
            echo "WARNING $file (setuid/setgid, package: $pkg, repository not clearly official, review required)"
        fi

    else
        #If dpkg does not know the file it may be manually installed or suspicious
        echo "KO $file (setuid/setgid, not managed by dpkg)"
    fi
done
