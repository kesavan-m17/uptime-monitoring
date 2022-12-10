#!/bin/bash

URL='<gchat-web-hook-url>'
IMAGE='Notification-image'
NOTIFY=$1
APP=$2
DOWN_AT=$3
UP_AT=$4
DOWNTIME=$5
ENV=Production

if [[ $NOTIFY == 'down' ]];
then
echo "DOWN"
curl -sL -o /dev/null --location --request POST $URL \
--header 'Content-Type: application/json' \
--data-raw '{
  "cards": [
    {
      "header": {
        "title": "<b>Service Monitoring</b>",
        "subtitle": "🔴 Application went down",
        "imageUrl": "'$IMAGE'"
      },
      "sections": [
        {
          "widgets": [
              {
              "textParagraph": {
                "text": "<b>APP : </b> '$APP'<br><b>Down At : </b> '$DOWN_AT'<br><b>ENVIRONMENT : </b> '$ENV'<br>"
              }
            }
          ]
        }

      ]
    }
  ],
  "thread": {
    "name": "spaces/AAAA9VjeU_8/threads/kZw0-6_aErk"
    }
}'
else
    echo "UP"
    curl -sL -o /dev/null --location --request POST $URL \
    --header 'Content-Type: application/json' \
    --data-raw '{
    "cards": [
        {
        "header": {
            "title": "<b>Service Monitoring</b>",
            "subtitle": "✅ Application is back online",
            "imageUrl": "'$IMAGE'"
        },
        "sections": [
            {
            "widgets": [
                {
                "textParagraph": {
                    "text": "<b>APP : </b> '$APP'<br><b>Down At : </b> '$DOWN_AT'<br><b>Up At : </b> '$UP_AT'<br><b>Down Time : </b> '$DOWNTIME'<br><b>ENVIRONMENT : </b> '$ENV'<br>"
                }
                }
            ]
            }

        ]
        }
    ],
    "thread": {
        "name": "spaces/AAAA9VjeU_8/threads/kZw0-6_aErk"
        }
    }'
fi
