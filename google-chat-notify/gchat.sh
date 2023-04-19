#!/bin/bash
 set -e
URL='https://your-webhook-url'
IMAGE='your app image'
NOTIFY=$1
APP=$2
DOWN_AT=$3
UP_AT=$4
ENV=DEV

# Example DOWNTIME array with spaces in the values
DOWNTIME=("$5""$6""$7")

# Loop through the array and trim leading/trailing spaces from each element
for ((i=0; i<${#DOWNTIME[@]}; i++)); do
  DOWNTIME[$i]="${DOWNTIME[$i]#"${DOWNTIME[$i]%%[![:space:]]*}"}"
  DOWNTIME[$i]="${DOWNTIME[$i]%"${DOWNTIME[$i]##*[![:space:]]}"}"
done

# Print the trimmed values in the DOWNTIME array
echo "Trimmed DOWNTIME array:"
for value in "${DOWNTIME[@]}"; do
  echo "'$value'"
done

DOWNTIME=("${DOWNTIME[@]// /\/}")

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
    curl -sL --location --request POST $URL \
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
                    "text": "<b>APP : </b> '$APP'<br><b>Down At : </b> '$DOWN_AT'<br><b>Up At : </b> '$UP_AT'<br><b>Down Time : </b> '${DOWNTIME[@]}'<br><b>ENVIRONMENT : </b> '$ENV'<br>"
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
