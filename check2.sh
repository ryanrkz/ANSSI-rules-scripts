#!/bin/bash
#This script is used in R18 and R20 to check values Linux kernel build configuration options
#Such values can be accessed in /boot/config-$(uname -r) or /proc/config.gz
#This script only checks if one value corresponds to the expected one
#so it is called once for each value to check
#This script prints "OK" if the actual value is equal to the expected one preceded by the name of the value checked
#or "KO" preceded by the name of the value checked and followed by the found value and the expected value in case they are different
#This script should not be run by itself, it is only used in other scripts

KEY="$1" #1st argument = The value we want to check (ex : CONFIG_MODULES)

EXPECTED="$2" #2nd argument = the expected value (recommended by ANSSI)

VALUE=$(sudo cat /boot/config-$(uname -r) 2>/dev/null | grep "^$KEY=" | cut -d= -f2-) #We first check the value in /boot/config-$(uname -r)
# /boot/config-$(uname -r) usually contains the configuration used to build the current kernel version (man uname :  -r : print the kernel release)
# $(uname -r) is command substitution and returns the current kernel release (man bash section Command substitution)
# 2>/dev/null hides error messages in case the file does not exist or cannot be read (as explained in check.sh)
#grep "^$KEY=" keeps only the line that starts with "KEY="
#cut -d= -f2- extracts everything after the '=' (the option value)
#option -d specifies the delimiter ('=' here)
#option -f2- selects the whole second field (here, the part after the '=') (source : man cut)

if [ -z "$VALUE" ]; then #if the value is empty (option not found or file not available)
	VALUE=$(zcat /proc/config.gz 2>/dev/null | grep "^$KEY=" | cut -d= -f2-) # we try to read the kernel config from /proc/config.gz
	# /proc/config.gz  contains the kernel configuration compressed
	#zcat decompresses the file and prints its content
	#the grep and cut steps work the same way as above
fi

if [ "$VALUE" = "$EXPECTED" ]; then #if the value found is the one in the ANSSI rule
	echo "$KEY : OK" #then we print the key followed by " : OK"
else #if the value found is not the one in the ANSSI rule, or if no value was found
	echo "$KEY : KO (got ${VALUE:-not found}, expected $EXPECTED)" #then we print KO and "got" followed by the value found then ", expected" followed by the expected value
	# ${VALUE:-not found} prints "not found" if VALUE is unset or empty
fi
