#! /bin/bash

balancers () {
	awk '
		BEGIN {s=""}
		/balancer.*internal/ {s="internal"}
		/balancer.*external/ {s="external"}
		/BalancerMember/ {print s " " $2}
	' < /cention/webserver/conf/httpd.conf |
	awk "/$1/"'{print $2}'
}

port () {
	echo $1 | cut -d: -f3
}

startservers () {
	for x in `balancers internal`;do
		ferite generic_chatserver.fe -- -port `port $x` -server InternalChat &
	done
	
	for x in `balancers external`;do
		ferite generic_chatserver.fe -- -port `port $x` -server ExternalChat &
	done
}

chatservers () {
	ps aux | awk '
		/awk|grepid/ {next}
		/ferite.*generic_chatserver/ {print $2}
	'
}

stopservers () {
	chatservers | xargs kill -9
}

case "$1" in

	#-----------------------------------------------------------------------
	# Debian required/optional targets:
	#-----------------------------------------------------------------------
	start)
		startservers
		;;
	stop)
		stopservers
		;;
	restart)
		stopservers
		startservers
		;;
	status)
		if [ "`chatservers`" == "" ];then
			echo No chat servers running
		else
			echo Chat servers running with the following pid:
			chatservers
		fi
		;;
	*)
		echo 'Usage: cention-chatserver {start|stop|status|restart}'
		;;
esac

