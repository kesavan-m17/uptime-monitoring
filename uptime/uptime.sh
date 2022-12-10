#!/bin/bash

APP=$1 # <Url Service name>
URL=$2 #'http://your-service-url.com'
ACCEPTED_CODE=[ $3 ] #200

hit(){
  STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" $URL | grep -v %)
}
cal_downtime(){  
  MPHR=60    # Minutes per hour.
  DOWNTIME=$(( ($UP - $DOWN) / $MPHR ))
}

hit
IS_DOWN=$(cat /tmp/is-downtime.txt)

if [[ $STATUS_CODE != $ACCEPTED_CODE && $IS_DOWN == " " && "! ${ACCEPTED_CODE[*]} " =~ " ${STATUS_CODE} "]];then    
  DOWN_AT=$(date '+%Y-%m-%d-%H:%M:%S')
  DOWN_SEC=$(date +%s)
  echo "$DOWN_SEC" > /tmp/is-downtime.txt
  echo "$DOWN_AT" > /tmp/downAt.txt
  uptime-monitoring/google-chat-notify/gchat.sh down $APP $DOWN_AT  
fi
if [[ $STATUS_CODE == $ACCEPTED_CODE && $IS_DOWN != " " && " ${ACCEPTED_CODE[*]} " =~ " ${STATUS_CODE} " ]];then     
   UP_AT=$(date '+%Y-%m-%d-%H:%M:%S')
   UP=$(date +%s)
   DOWN=$(cat /tmp/is-downtime.txt)
   DOWN_AT=$(cat /tmp/downAt.txt)
   cal_downtime
   uptime-monitoring/google-chat-notify/gchat.sh up $APP $DOWN_AT $UP_AT $DOWNTIME-mins
   echo " " > /tmp/is-downtime.txt
   exit 0
fi
