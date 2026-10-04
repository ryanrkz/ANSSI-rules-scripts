This folder contains Bash scripts to check several ANSSI security recommendations on a Linux system.
They just report if the rule expectations are met (OK / NOT OK) and don't change anything.

Main scripts (ANSSI rules)
R9.sh: checks kernel sysctl security values
R10.sh: checks if kernel module loading is disabled
R12-13.sh: checks IPv4 sysctl hardening and disables IPv6 if not used
R18.sh: checks kernel module signature options
R20.sh: checks Seccomp / LSM / Yama kernel security options
R28.sh: checks mount options on many partitions (nosuid, nodev, noexec, etc.)
R32.sh: checks session lock after inactivity (systemd logind)
R36.sh: checks UMASK for users (0077) and running services (0027 or stricter)
R40.sh: finds sudo rules that run commands as root
R42.sh: finds sudo rules using negation (!)
R56.sh: lists setuid/setgid files and checks if they come from trusted packages
R59.sh: lists APT repositories that are not official Ubuntu ones

Helper scripts
Some scripts are used by other scripts.
check.sh: checks one sysctl value (kernel parameter) and compares it to the expected value
check2.sh: checks one kernel build option (from /boot/config-* or /proc/config.gz)

Since some scripts depend on other ones, you must have all the scripts in the same folder.

To use these scripts, you have to first make them executable (using chmod u+x *.sh for example).

A script called runall.sh is included to run all ANSSI checks automatically, one after another.

Each script runs separately and does not need any argument from you.
Examples of executions : 
./R9.sh
./R28.sh
./R59.sh

Output
Scripts print results like :
OK
NOT OK (got ..., expected ...)
WARNING ... (in some rare cases)
Every time a rule appears to not be respected, the system value and the expected value are displayed so the user can judge the severity of the problem.


Some scripts use sudo, in this case you do not need to execute it using sudo but you will be asked to put your password to continue the script execution.

The scripts use common Linux commands and usually do not require installing extra tools.
However some checks may need systemd tools (systemctl) or Debian/Ubuntu tools (dpkg, apt-cache).

In some scripts multiple ways to check a value are implemented. 
We did that to stay compatible with different environments (dual boot Linux, WSL, etc.).

We mainly worked on WSL but still tested our scripts on a regular Linux system, but sometimes in both cases the values we wanted to check were not found.
In these cases, the output is NOT OK (got not found, expected ...)

