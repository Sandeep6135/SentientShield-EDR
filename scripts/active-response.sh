#!/bin/bash
# Sentient Shield Active Response: IP Ban via IPTables
# Triggered by Wazuh Manager after 5 failed login attempts

ACTION=$1
USER=$2
IP=$3

if [ "$ACTION" == "add" ]; then
    iptables -I INPUT -s "$IP" -j DROP
    echo "$(date) - Banned IP $IP due to brute force attempt" >> /var/ossec/logs/active-responses.log
elif [ "$ACTION" == "delete" ]; then
    iptables -D INPUT -s "$IP" -j DROP
fi