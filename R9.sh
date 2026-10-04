#!/bin/bash
#This script is used to check values of the kernel parameters listed in R9 of ANSSI
#It uses the check.sh script which checks a value located in /proc/sys and compares it to the wanted value and produces an output depending on the result of this comparison
#R9 provides recommended values for Linux kernel sysctl parameters to improve system security
#For each check we will explain the goal of the expected R9 value

./check.sh kernel.dmesg_restrict 1  #Restricts access to the dmesg buffer

./check.sh kernel.kptr_restrict 2 #Hides kernel addresses

./check.sh kernel.perf_event_paranoid 2 #Restricts unprivileged access to perf events

./check.sh kernel.randomize_va_space 2 #Enables ASLR (address space layout randomization)

./check.sh kernel.sysrq 0 #Disables Magic sysrq key combinations

./check.sh kernel.unprivileged_bpf_disabled 1 #Restricts BPF (Berkeley packet filter) usage to privileged users

./check.sh kernel.panic_on_oops 1 #Stops the system on unexpected kernel behavior
