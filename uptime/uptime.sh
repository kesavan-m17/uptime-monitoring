#!/bin/bash

APP=$1 #Fidy-Pay 
URL=$2 #'http://local-api.fidypay.com'
ACCEPTED_CODE=$3 #404

hit(){
  STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" $URL | grep -v %)
}
cal_downtime(){  
  MPHR=60    # Minutes per hour.
  DOWNTIME=$(( ($UP - $DOWN) / $MPHR ))
}

hit
IS_DOWN=$(cat /tmp/is-downtime.txt)

if [[ $STATUS_CODE != $ACCEPTED_CODE && $IS_DOWN == " " ]];then    
  DOWN_AT=$(date '+%Y-%m-%d-%H:%M:%S')
  DOWN_SEC=$(date +%s)
  echo "$DOWN_SEC" > /tmp/is-downtime.txt
  echo "$DOWN_AT" > /tmp/downAt.txt
  ~/gchat-notifier.sh down $APP $DOWN_AT  
fi
if [[ $STATUS_CODE == $ACCEPTED_CODE && $IS_DOWN != " " ]];then     
   UP_AT=$(date '+%Y-%m-%d-%H:%M:%S')
   UP=$(date +%s)
   DOWN=$(cat /tmp/is-downtime.txt)
   DOWN_AT=$(cat /tmp/downAt.txt)
   cal_downtime
   ~/gchat-notifier.sh up $APP $DOWN_AT $UP_AT $DOWNTIME-mins
   echo " " > /tmp/is-downtime.txt
   exit 0
fi
