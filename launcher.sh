#!/bin/bash
set -e
krb5kdc -n &
sleep 2
kadmind -nofork &
sleep 1
tail -f /var/log/krb5kdc.log &
tail -f /var/log/kadmind.log

