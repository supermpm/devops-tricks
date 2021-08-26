#!/bin/bash

SSH_FROM_IP='Some IP'
GOOGLE_DNS1='8.8.8.8'
GOOGLE_DNS2='8.8.4.4'

input_rules() {
	#ssh from some host
	iptables -A INPUT -i eth0 -s $SSH_FROM_IP -p tcp --dport 22 -m state --state NEW -j ACCEPT
	#http
	iptables -A INPUT -i eth0 -p tcp --dport 80 -m state --state NEW -j ACCEPT
	#https
	iptables -A INPUT -i eth0 -p tcp --dport 443 -m state --state NEW -j ACCEPT
}

output_rules() {
	#smtp output
	iptables -A OUTPUT -o eth0 -p tcp --dport 25 -m state --state NEW -j ACCEPT
	iptables -A OUTPUT -o eth0 -p tcp --dport 587 -m state --state NEW -j ACCEPT
	iptables -A OUTPUT -o eth0 -p tcp --dport 465 -m state --state NEW -j ACCEPT
	#if you use smtp relay
	#iptables -A OUTPUT -o eth0 -p tcp -d put_here_relay_ip --dport 25 -m state --state NEW -j ACCEPT
	
	#google dns output
	iptables -A OUTPUT -o eth0 -d $GOOGLE_DNS1 -p udp --dport 53 -m state --state NEW -j ACCEPT
	iptables -A OUTPUT -o eth0 -d $GOOGLE_DNS2 -p udp --dport 53 -m state --state NEW -j ACCEPT
}

established_rules() {
	#accept established inputs
	iptables -A INPUT -i eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
	#accept established outputs
	iptables -A OUTPUT -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
}

flush_rules() {
	iptables -F
	iptables -X
	iptables -t nat -F
	iptables -t nat -X
	iptables -t mangle -F
	iptables -t mangle -X
}

default_drop() {
	#default policy drop
	iptables -P INPUT DROP
	iptables -P OUTPUT DROP
	iptables -P FORWARD DROP
}

default_accept() {
	#default policy accept
	iptables -P INPUT ACCEPT
	iptables -P OUTPUT ACCEPT
	iptables -P FORWARD ACCEPT
}

start_firewall() {
	flush_rules
	input_rules
	output_rules
	established_rules
}

stop_firewall() {
	default_accept
	flush_rules
}

case $1 in
	start)
		start_firewall
	;;
	stop)
		stop_firewall
	;;
	restart)
		stop_firewall
		start_firewall
	;;
	*)
		echo "Use: $0 [start|stop|restart]"
		exit 1
	;;
esac
