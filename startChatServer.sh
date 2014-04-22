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

for x in `balancers internal`;do
	ferite generic_chatserver.fe -- -port `port $x` -server InternalChat &
done

for x in `balancers external`;do
	ferite generic_chatserver.fe -- -port `port $x` -server ExternalChat &
done
