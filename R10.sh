#!/bin/bash
#This script is used to check the values of the kernel parameter mentionned in R10 of ANSSI
#It uses the check.sh script which checks a value located in /proc/sys and compares it to the wanted value and produces an output depending on the result of this comparison
#R10 recommends disabling kernel module loading to prevent malicious or vulnerable modules from being loaded

./check.sh kernel.modules_disabled 1 # Disables the loading of new kernel modules (including by root)
