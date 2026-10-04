#!/bin/bash
#This script checks the kernel compilation options listed in ANSSI R20
#It uses the check2.sh script, which reads a kernel build option from the kernel config and compares it to the expected value
#R20 recommends enabling kernel security primitives (Seccomp and LSM support) and enabling Yama, while ensuring LSM hooks are not writable
#For each check we will explain the goal of the expected R20 value

./check2.sh CONFIG_SECCOMP y #Enables the ability to filter system calls made by an application

./check2.sh CONFIG_SECCOMP_FILTER y #Enables the ability to use BPF scripts

./check2.sh CONFIG_SECURITY y #Enables Linux kernel security primitives

./check2.sh CONFIG_SECURITY_YAMA y #Enables Yama to restrict usage of the ptrace() system call

./check2.sh CONFIG_SECURITY_WRITABLE_HOOKS "is not set" #Ensures LSM kernel structures are not writable after boot
