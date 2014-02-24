#!/bin/bash

### PARAMETERS
MON_ITEM=$1
#be careful with url
NGINX_STATUS_URL=http://127.0.0.1/nginx-status/
CURL=/usr/bin/curl
CACHE_TTL=1
CACHE_FILE=/usr/local/zabbix/var/`basename $0`.cache

### RUN
## Check cache file
CACHE_FIND=`find $CACHE_FILE -mmin -$CACHE_TTL 2>/dev/null`
if [ -z "$CACHE_FIND" ] || ! [ -s "$CACHE_FILE" ];then
	$CURL -s $NGINX_STATUS_URL > $CACHE_FILE 2>/dev/null || exit 1
fi

case "$MON_ITEM" in
	"active_connections")
		awk '/Active/ {print $NF}' $CACHE_FILE
		;;
	"accepted_connections")
		awk 'NR==3 {print $1}' $CACHE_FILE
		;;
	"handled_connections")
		awk 'NR==3 {print $2}' $CACHE_FILE
        ;;
	"handled_requests")
		awk 'NR==3 {print $3}' $CACHE_FILE
		;;
	"reading")
		awk '/Reading/ {print $2}' $CACHE_FILE
		;;
	"writing")
		awk '/Writing/ {print $4}' $CACHE_FILE
    	;;
	"waiting")
		awk '/Waiting/ {print $6}' $CACHE_FILE
		;; 
	*)
	 	echo "ZBX_NOTSUPPORTED"
		exit 1
		;;
esac
exit 0