#!/bin/bash
#This script checks the kernel compilation options listed in ANSSI R18
#It uses the check2.sh script, which reads a kernel build option from the kernel config and compares it to the expected value
#R18 recommends enabling module support while enforcing module signature verification to harden kernel module management
#For each check we will explain the goal of the expected R18 value

./check2.sh CONFIG_MODULES y  #Enables support for kernel modules

./check2.sh CONFIG_STRICT_MODULE_RWX y #Enables strict permissions for module memory (RWX restriction)

./check2.sh CONFIG_MODULE_SIG y #Enables module signature support

./check2.sh CONFIG_MODULE_SIG_FORCE y  #Refuses loading of unsigned modules or modules signed with an untrusted key

./check2.sh CONFIG_MODULE_SIG_ALL y   #Automatically signs modules during installation

./check2.sh CONFIG_MODULE_SIG_SHA512 y #Uses SHA-512 for module signature hashing

./check2.sh CONFIG_MODULE_SIG_HASH "\"sha512\""  #Sets the module signature hash algorithm to sha512

./check2.sh CONFIG_MODULE_SIG_KEY "\"certs/signing_key.pem\""  #Sets the path to the key/certificate used to sign modules
