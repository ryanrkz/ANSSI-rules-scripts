#!/bin/bash
#This script is used to check values of the network parameters listed in R12 and R13 of ANSSI
#It uses the check.sh script which checks a value located in /proc/sys and compares it to the wanted value and produces an output depending on the result of this comparison
#R12 recommends IPv4 sysctl settings for a typical server host with no routing and a minimal IPv4 configuration
#For each check we will explain the goal of the expected R12 value
./check.sh net.core.bpf_jit_harden 2  #Mitigates the JIT dispersion effect 
./check.sh net.ipv4.ip_forward 0 #No routing between interfaces
./check.sh net.ipv4.conf.all.accept_local 0 #Rejects external packets with a 127/8 source address
./check.sh net.ipv4.conf.all.accept_redirects 0  #Refuses ICMP redirect packets
./check.sh net.ipv4.conf.default.accept_redirects 0 #Refuses ICMP redirect packets (default)
./check.sh net.ipv4.conf.all.secure_redirects 0  #Refuses ICMP redirect packets (secure redirects)
./check.sh net.ipv4.conf.default.secure_redirects 0 #Refuses ICMP redirect packets (secure redirects, default)
./check.sh net.ipv4.conf.all.shared_media 0 #Disables shared media behavior
./check.sh net.ipv4.conf.default.shared_media 0 #Disables shared media behavior (default)
./check.sh net.ipv4.conf.all.accept_source_route 0 #Refuses source routing information from packets
./check.sh net.ipv4.conf.default.accept_source_route 0 #Refuses source routing information from packets (default)
./check.sh net.ipv4.conf.all.arp_filter 1  #Prevents global ARP table handling
./check.sh net.ipv4.conf.all.arp_ignore 2 #Only replies to ARP requests in specific conditions
./check.sh net.ipv4.conf.all.route_localnet 0 #Refuses routing involving loopback addresses (127/8)
./check.sh net.ipv4.conf.all.drop_gratuitous_arp 1 #Ignores gratuitous ARP requests
./check.sh net.ipv4.conf.default.rp_filter 1 #Enables source address verification (default)
./check.sh net.ipv4.conf.all.rp_filter 1 #Enables source address verification
./check.sh net.ipv4.conf.default.send_redirects 0 #Disables sending ICMP redirects (default)
./check.sh net.ipv4.conf.all.send_redirects 0 #Disables sending ICMP redirects
./check.sh net.ipv4.icmp_ignore_bogus_error_responses 1 #Ignores non compliant ICMP responses (RFC 1122)
./check.sh net.ipv4.tcp_rfc1337 1 #Enables RFC 1337 behavior
./check.sh net.ipv4.tcp_syncookies 1 #Enables SYN cookies (SYN flood prevention)

#R13 recommends disabling IPv6 when it is not used.
./check.sh net.ipv6.conf.default.disable_ipv6 1 #Disables IPv6 (default)
./check.sh net.ipv6.conf.all.disable_ipv6 1 #Disables IPv6 (all interfaces)
