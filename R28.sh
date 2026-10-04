#!/bin/bash
#This script checks the mount options of several mount points recommended in ANSSI R28
#It uses findmnt to retrieve the mount options of a given mount point, then verifies that the expected options are present
#R28 recommends a partitioning layout with specific mount options to limit the allowed actions on each partition
#We use a function (check) to avoid repeating the same code for each mount point
check(){
    POINT="$1" #1st argument=the mount point to check (ex : /tmp)
    OPTION="$2" #2nd argument=the expected mount options for this mount point (ex :  nosuid,nodev,noexec)
    OPTIONS=$(findmnt -n -o OPTIONS "$POINT" 2>/dev/null) #Get the mount options for POINT using findmnt
     #findmnt -n outputs without header lines
      #-o OPTIONS prints only the "OPTIONS" column (man findmnt)
      #2>/dev/null hides error messages if the mount point is not found

    if echo "$OPTIONS" | grep -qw "$OPTION"; then #if the expected options appear in the found options
        #-q makes grep quiet (no output, only exit code)
        #-w matches whole words (man grep)
        
        echo "$POINT : OK ($OPTION)" #Print "OK" if the expected options are found
    else
        echo "$POINT : KO (got ${OPTIONS:-not found}, expected $OPTION)"  #Print "KO" and show found options (or "not found") and expected options
        # ${OPTIONS:-not found} prints "not found" if OPTIONS is empty
    fi
}
check / #Root partition, no option expected
check /boot nosuid,nodev,noexec
check /opt nosuid,nodev
check /tmp nosuid,nodev,noexec
check /srv nosuid,nodev
check /home nosuid,nodev,noexec
check /proc hidepid=2
check /usr nodev
check /var nosuid,nodev,noexec
