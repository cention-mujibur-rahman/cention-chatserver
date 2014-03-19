#! /bin/bash

CMD=getUpdate
HOST=localhost:9090
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
		-command)
			CMD="$1"
			shift
			;;
		*)	HOST=$op
			;;
	esac
done

chat_protocol () {
	case "$1" in
		getUpdate)
			curl -s "http://${HOST}/Cention/chat/harmony/-/MCAM/GlobalChat.getUpdate" \
				-H 'Origin: http://localhost' \
				-H 'Accept-Encoding: gzip,deflate,sdch' \
				-H 'Accept-Language: en-US,en;q=0.8,ms;q=0.6' \
				-H 'Content-Type: application/x-www-form-urlencoded' \
				-H 'Accept: */*' \
				-H "Cookie: ${COOKIES[*]}" \
				-H 'Connection: keep-alive' \
				--data 'areas=1%2C3%2C2%2C4&users=2' \
				--compressed
			;;
	esac
}

echo "[Response]========================================================"
json=`chat_protocol "$CMD"`

if [ $ENVELOPE -eq 0 ];then
	echo $json | python -m json.tool |
	awk '/"content"\s*:/ {gsub(/"content"\s*:/,"");gsub(/\\/,"");gsub(/"{/,"{");gsub(/",$/,"");print $0; exit}' |
	python -m json.tool
else
	echo $json | python -m json.tool
fi

echo
echo "=================================================================="

