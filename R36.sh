#!/bin/bash
#This script checks UMASK values for to ANSSI R36
#R36 recommends :
#Setting the default UMASK for user shells to 0077
#Setting the default UMASK for services to 0027 (or more restrictive)
#The script performs two checks
#For user shells it runs a login shell for each local user and prints the resulting umask
#For services it reads the UMask property of each running service and verifies it is 0027 or more restrictive

EXPECTED="0077" #Expected UMASK value for user shells (R36)

EXP_SVC="0027" #Recommended UMASK value for services (R36), 0027 or more restrictive is accepted

for user in $(awk -F: '{print $1}' /etc/passwd); do #Loop over all local accounts listed in /etc/passwd
#awk -F: sets ':' as the field separator
#{print $1} prints the first field of each line, which is the username
	
	VALUE=$(sudo -u "$user" sh -l -c 'umask' 2>/dev/null)  #Get the umask of the user's login shell
	#sudo -u "$user" runs the command as the given user
	#sh -l starts a login shell, which should load login configuration
	#-c 'umask' runs the umask command inside that shell and prints the current umask value
	#2>/dev/null hides error messages (accounts may have no login shell or may not be allowed to run a shell)
	
	if [ "$VALUE" = "$EXPECTED" ]; then  #Check if the user's umask is exactly 0077 as required by R36
		echo "$user : OK"  #Print OK if the value matches
	else
		echo "$user : KO (got ${VALUE:-not found}, expected $EXPECTED)" #Print KO if different or missing
		#${VALUE:-not found} prints "not found" if VALUE is empty (no output was returned for this user)
	fi
done

#services part
for svc in $(systemctl list-units --type=service --state=running --no-legend | awk '{print $1}'); do #Loop over all running systemd services
#systemctl list-units --type=service lists only service units
#--state=running restricts the list to currently running services
#--no-legend removes the header line
#awk '{print $1}' extracts the name 
	
	val=$(systemctl show "$svc" -p UMask --value 2>/dev/null) #Read the UMask applied by systemd to this service 
	#systemctl show prints properties of a unit
	#-p UMask selects only the UMask property
	#--value outputs only the  value without "UMask="
	#2>/dev/null hides errors if the property can not be read

	#R36 says that service UMASK should be 0027 or more restrictive
	#For umask values, "more restrictive" means a larger octal number
	#We compare values numerically in base 8 (octal) using the syntax 8#VALUE
	if [ -n "$val" ] && (( 8#$val >= 8#$EXP_SVC )); then #Check that val exists and is >= 0027 (octal comparison)
	#-n "$val" ensures the value is not empty (otherwise numeric comparison would fail)
		echo "$svc : OK" #Print OK if the service umask is correct according to the conditions of R36
	else
		echo "$svc : KO (got ${val:-not found}, expected $EXP_SVC or more restrictive)"  #Print KO if too permissive or missing
		#${val:-not found} prints "not found" if val is empty
	fi
done
