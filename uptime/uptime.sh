#!/bin/bash

set -e

# Export Variables
CURRENT=$(date +"%Y-%m-%d %H:%M:%S")
URL='http://localhost'
APP=my-uptime

ping(){
    STATUS_CODE=$(curl -sI $URL | grep HTTP | cut -d " " -f 2)
}
# Function to calculate time difference
time_diff(){
    # Convert the date-time values to Unix timestamps
    START_TIME=$(date -d "$START" +%s)
    END_TIME=$(date -d "$END" +%s)

    # Calculate the time difference in seconds
    time_difference=$((END_TIME - START_TIME))

    hours=$((time_difference / 3600))
    minutes=$(( (time_difference % 3600) / 60 ))
    seconds=$((time_difference % 60))

    # Format the DOWNTIME
    output=""
    if [ $hours -gt 0 ]; then
        output+=" $hours-hour"
    fi
    if [ $minutes -gt 0 ]; then
        output+=" $minutes-min"
    fi
    if [ $seconds -gt 0 ]; then
        output+=" $seconds-sec"
    fi

    # Print the time difference
    echo "The APP Down Time = $output"
    DOWNTIME=$output    
}

# Function to handle UP status
UP(){
    if [[ $(cat /tmp/STATUS.txt) == "UP" ]]; then
        echo "UP=true" > /tmp/STATUS.txt
        END=$(date "+%Y-%m-%d %H:%M:%S")
        UP_AT=$(date '+%Y-%m-%d-%H:%M:%S')
        time_diff
        # notify-send 'APP is UP'
        echo "$DOWNTIME"
        uptime-monitoring/google-chat-notify/gchat.sh up $APP $DOWN_AT $UP_AT $DOWNTIME        
        exit 0            
    fi
    if [[ $(cat /tmp/STATUS.txt) == "UP=true" ]]; then
        echo "Already UP"
        exit 0
    fi
}

# Function to handle DOWN status
DOWN(){
    ping    
    echo "DOWN" > /tmp/STATUS.txt
    until [[ "$STATUS_CODE" == "200" ]]; do            
        ping                
        STATUS=$(cat /tmp/STATUS.txt)
        if [[ "$STATUS_CODE" == "200" ]]; then
            echo "UP" > /tmp/STATUS.txt
            UP
        fi    
        case $STATUS in
            DOWN=true) echo "Already DOWN" > /tmp/null.txt
            ;;
            DOWN) 
            START=$(date "+%Y-%m-%d %H:%M:%S")         
            DOWN_AT=$(date '+%Y-%m-%d-%H:%M:%S')
            uptime-monitoring/google-chat-notify/gchat.sh down $APP $DOWN_AT
            echo "DOWN=true" >> /tmp/STATUS.txt
            time
            ;;
        esac
        sleep 5
    done
}
ping
if [[ "$STATUS_CODE" == "200" ]]; then    
    UP
else
    DOWN
fi
