#!/bin/sh

SLEEP_INTERVAL=${SLEEP_INTERVAL:-2} 

if [ -z "$@" ]
then
    echo "You should set call recipient"
    echo "SLEEP_INTERVAL=<pause between attempts in seconds> $0 <call recipient>"

    exit 0
fi

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

function interrupt {
    ACTIVE_CALLS=$(linphonecsh generic calls)
    if [ "$ACTIVE_CALLS" == 'No active call.' ]
    then
        echo "No active call, exititing..."
        exit 1
    else
        echo "$ACTIVE_CALLS"
        echo "Terminate call with ID: $CALL_ID"
        linphonecsh generic terminate $CALL_ID
        exit 1
    fi

}

trap interrupt INT

while true
do
    for CALL_RECIPIENT in "$@"
    do
        ACTIVE_CALLS=$(linphonecsh generic calls | tail -1)
        if [ "$ACTIVE_CALLS" = 'No active call.' ]
        then
            CALL_ID=$(linphonecsh dial $CALL_RECIPIENT | awk '/Call/ {print $2}')
            echo "Calling to $CALL_RECIPIENT with call id $CALL_ID"
            sleep $SLEEP_INTERVAL
        else
            printf "\r%s" "$ACTIVE_CALLS"
            sleep $SLEEP_INTERVAL
        fi
    done
done
