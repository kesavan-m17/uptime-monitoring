## Uptime-Monitoring
* You can use this Uptime with bash.
* Low memory and CPU consumption.

## Needed Arguments

* APP=$1 # <Url Service name>
* URL=$2 #'http://your-service-url.com'
* ACCEPTED_CODE=$3 #200

```
1. APP - Your Service name which you need to monitor
2. URL - Your Service URL which you need to monitor.
3. ACCEPTED_CODE = Eg. 200, 404,302
```

* You need to run this scrpit via Cronjob
* Eg.
``` 
6 * * * * /uptime-monitoring/uptime/uptime.sh <Service name> <Service URL> <Status Code eg. 200>
```
