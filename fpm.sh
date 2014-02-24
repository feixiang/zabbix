#!/bin/bash

### PARAMETERS
MON_ITEM=$1
PHP_FPM_STATUS_URL=http://127.0.0.1/status
CURL=/usr/bin/curl
CACHE_TTL=1
CACHE_FILE=/usr/local/zabbix/var/`basename $0`.cache

### RUN
## Check cache file
CACHE_FIND=`find $CACHE_FILE -mmin -$CACHE_TTL 2>/dev/null`
if [ -z "$CACHE_FIND" ] || ! [ -s "$CACHE_FILE" ];then
	$CURL -s $PHP_FPM_STATUS_URL > $CACHE_FILE 2>/dev/null || exit 1
fi


case "$MON_ITEM" in
	"accepted_conn")
		awk '/^accepted conn:/ {print $NF}' $CACHE_FILE
		;;
	"idle_procs")
		awk '/^idle processes:/ {print $NF}' $CACHE_FILE
		;;
	"active_procs")
		awk '/^active processes:/ {print $NF}' $CACHE_FILE
        ;;
	"total_procs")
		awk '/^total processes:/ {print $NF}' $CACHE_FILE
		;;
    "listen_queue")
		awk '/^listen queue:/ {print $NF}' $CACHE_FILE
		;;
	"listenqueue_len")
		awk '/^listen queue len:/ {print $NF}' $CACHE_FILE
		;;
	"max_active_processes")
		awk '/^max active processes:/ {print $NF}' $CACHE_FILE
		;;
	"maxchildren_reached")
		awk '/^max children reached:/ {print $NF}' $CACHE_FILE
    	;;
	"slow_requests")
		awk '/^slow requests:/ {print $NF}' $CACHE_FILE
		;; 
	*)
	 	echo "ZBX_NOTSUPPORTED"
		exit 1
		;;
esac
exit 0