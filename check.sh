#!/bin/bash
#This script is used in R9, R10 and R12/13 to check values located in /proc/sys
#Such values can be accessed using the sysctl command (if it is available)
#This script only checks if one value corresponds to the expected one
#so it is called once for each value to check
#This script prints "OK" if the actual value is equal to the expected one preceded by the name of the value checked
#or "KO" preceded by the name of the value checked and followed by the found value and the expected value in case they are different
#This script should not be run by itself, it is only used in other scripts

KEY="$1" #1st argument = The value we want to check (ex : kernel.dmesg_restrict)

EXPECTED="$2" #2nd argument = the expected value (recommended by ANSSI)

VALUE=$(sysctl -n "$KEY" 2>/dev/null) #We first search the value using sysctl command
#The -n option is used to "disable printing of the key name when printing values" (source : man sysctl)
#2>/dev/null is used to redirect error messages (stderr) so they don't go in the script output
#2 is the standard file descriptor for stderr
#"Data written to the /dev/null and /dev/zero special files is discarded." (source : man null)
#this redirection will be used many times in the other scripts (and in this one)

if [ -z "$VALUE" ]; then #if the value is empty
#this can happen if the sysctl command is not installed

	VALUE=$(cat "/proc/sys/${KEY//./\/}" 2>/dev/null) #then we try to read it directly from /proc/sys
	#The keys in the rule instructions are given with '.' (ex : kernel.dmesg_restrict)
	#but we want them with '/' (ex : kernel/dmesg_restrict)
	#because the value kernel.dmesg_restrict is stored in /proc/sys/kernel/dmesg_restrict
	#so we use ${KEY//./\/} to turn '.' in the key into '/'
	#it follows the syntax : ${parameter//pattern/string} (found in man bash, section EXPANSION, parameters expansion)
	#since '/' is used as a separator in this syntax, we use '\' as an escape character so the last '/' is not interpreted as a delimiter
fi
if [ -z "$VALUE" ]; then #if the value is still empty
	VALUE=$(sudo sysctl -n "$KEY" 2>/dev/null) #then we retry the sysctl command with sudo in case root permissions are required
	#this is useful for example in R12 for net.core.bpf_jit_harden
fi

if [ "$VALUE" = "$EXPECTED" ]; then #if the value found is the one in the ANSSI rule
	
	echo "$KEY : OK" #then we print the key followed by " : OK"

else #if the value found is not the one in the ANSSI rule, or if no value was found
	
	echo "$KEY : KO (got ${VALUE:-not found}, expected $EXPECTED)" #then we print KO and "got" followed by the value found then ", expected" followed by the expected value
	#we use the syntax ${parameter:-word} (found in man bash, section EXPANSION, parameters expansion)
	#this allows to replace the value of a parameter by a default value if it is unset or null
	#here it is used to print "not found" when the value is empty
	
fi
