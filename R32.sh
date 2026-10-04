#!/bin/bash
#This script checks the configuration related to R32 of ANSSI
#R32 requires local user sessions (TTY console, graphical sessions) to be locked after a period of inactivity
#The script reads the IdleAction setting from /etc/systemd/logind.conf and compares it to the expected value, which is "lock"

EXPECTED="#IdleAction=lock" #Expected configuration line for IdleAction
#IdleAction=lock is expected because R32 requires local user sessions to be locked after a period of inactivity to prevent unauthorized access

VALUE=$(grep "IdleAction=" /etc/systemd/logind.conf 2>/dev/null) #Search for the IdleAction setting in logind.conf
#2>/dev/null hides error messages if the file cannot be read


if [ "$VALUE" = "$EXPECTED" ]; then #Check if the current value matches the expected one
  echo "OK" #Print OK if it matches
else
  echo "KO (got ${VALUE:-not found}, expected $EXPECTED)" #Print KO and show found value (or "not found") and expected value
  #${VALUE:-not found} prints "not found" if VALUE is empty
fi
