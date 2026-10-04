#!/bin/bash
#Run all ANSSI check scripts (R9, R10, R12/13, R18, R20, R28, R32, R36, R40, R42, R56, R59)
#Make sure this script is in the same folder as all other scripts
echo "===== R9 ====="
./R9.sh
echo
echo "===== R10 ====="
./R10.sh
echo
echo "===== R12/R13 ====="
./R12-13.sh
echo
echo "===== R18 ====="
./R18.sh
echo
echo "===== R20 ====="
./R20.sh
echo
echo "===== R28 ====="
./R28.sh
echo
echo "===== R32 ====="
./R32.sh
echo
echo "===== R36 ====="
./R36.sh
echo
echo "===== R40 ====="
./R40.sh
echo
echo "===== R42 ====="
./R42.sh
echo
echo "===== R56 ====="
./R56.sh
echo
echo "===== R59 ====="
./R59.sh
echo
