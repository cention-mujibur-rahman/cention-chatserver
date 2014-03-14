#! /bin/bash

httpRequest() {
	./getUpdate.sh $TEST_HOST 2> /dev/null |
	grep 'count'
}

while [ true ];do
	START=`date +%s%N`
	if [ "`httpRequest`" != "" ];then
		NOW=`date +%s%N`
		echo $[ ( $NOW - $START ) / 1000000 ] >> .stats.raw
	else
		echo . >> .stats.error
	fi
	sleep 1
done
