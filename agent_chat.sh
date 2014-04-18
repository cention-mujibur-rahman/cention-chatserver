#! /bin/bash

CMD=''
DATA=''
HOST=localhost
ENVELOPE=0
COOKIES=(
	'cention-suiteWFUserID=2;'
	'cention-suiteWFPassword=kW83un60RZvFwuehOluJiCws7VU9yOKcdTsSt060ZBI=;'
	'webframework-session-id=webframework;'
	'webframework-session-voucher=TLBHTFIQKEKFWGFP'
)

ARGV="$@"

while [ $# -gt 0 ];do
	op="$1"
	shift
	case "$op" in
		-host)
			HOST="$1"
			shift
			;;
		-envelope)
			ENVELOPE=1
			;;
		-host)
			HOST="$1"
			shift
			;;
		-data)
			DATA="$1"
			shift
			;;
		*)
			CMD="$op"
			;;
	esac
done


mcam () {
	method=$1
	data=$2
	curl -s "http://${HOST}/Cention/chat/harmony/-/MCAM/GlobalChat.${method}" \
		-H 'Origin: http://localhost' \
		-H 'Accept-Encoding: gzip,deflate,sdch' \
		-H 'Accept-Language: en-US,en;q=0.8,ms;q=0.6' \
		-H 'Content-Type: application/x-www-form-urlencoded' \
		-H 'Accept: */*' \
		-H "Cookie: ${COOKIES[*]}" \
		-H 'Connection: keep-alive' \
		--data "$data" \
		--compressed
}

default () {
	var="$1"
	def="$2"
	if [ "$var" == "" ];then
		echo $2
	else
		echo $1
	fi
}

chat_protocol () {
	case "$1" in
		getUpdate)
			mcam getUpdate \
				`default "$DATA" 'areas=1%2C3%2C2%2C4&users=2'`
			;;
		acquireSession)
			mcam acquireSession \
				`default "$DATA" 'session=20'`
			;;
		markAsSeen)
			mcam markAsSeen \
				`default "$DATA" 'sessions=20'`
			;;
		sendMessage)
			mcam sendMessage \
				`default "$DATA" 'session=20&text=hello'`
			;;
		finishChatSessionTag)
			mcam finishChatSessionTag \
				`default "$DATA" 'value=20&withTag=notag&tagid=-1&id=0'`
			;;
	esac
}

if [ "$CMD" == "" ];then
	echo Agent chat client.
	echo Available commands:
	echo "  " getUpdate
	echo "  " acquireSession -data session=NUMBER
	echo "  " markAsSeen -data sessions=NUMBER
	echo "  " sendMessage -data "'session=NUMBER&text=STRING'"
	echo "  " finishChatSessionTag -data "'value=NUMBER&withTag=notag&tagid=-1&id=0'"
	exit
fi

json=`chat_protocol "$CMD"`

if [ $ENVELOPE -eq 0 ];then
	echo $json | ./jsontool.fe -- -find mcam.channels[0].content -plain 2> /dev/null |
	./jsontool.fe 2> /dev/null
else
	echo $json | ./jsontool.fe 2> /dev/null
fi

echo

