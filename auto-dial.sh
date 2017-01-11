#!/bin/sh

for prog_name in linphone linphonec linphonecsh
do
    hash ${prog_name} 2>/dev/null || { echo >&2 "I require ${prog_name} but it's not installed. Visit http://www.linphone.org/ . Aborting."; exit 1; }
done

# check oif daemon started
linphonecsh status registered > /dev/null 2>&1 

if [[ $? == 255 ]]
then
    echo "Linphone daemon havn't started yet. Starting it with ~/.linphonerc as configuration file"
    linphonecsh init -c ~/.linphonerc

    sleep 2
fi;

REGISTER_STATUS=$(linphonecsh status registered)
if [[ $? == 0 ]]
then
    echo "SIP account havn't configured properly. Please check your account and linphone configuration."
    exit 0
else
    echo $REGISTER_STATUS
fi
