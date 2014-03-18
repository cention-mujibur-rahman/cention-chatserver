#! /bin/bash

HOST=localhost:9090
ENVELOPE=0

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
		*)	HOST=$op
			;;
	esac
done

echo "[Response]========================================================"
json=$(
	wget "http://${HOST}/Cention/chat/harmony/-/MCAM/GlobalChat.getUpdate" \
		--post-data='&areas=1%2C3%2C2%2C4&users=2' \
		--no-cookie \
		--header 'Cookie: cention-suiteWFUserID=2; cention-suiteWFPassword=kW83un60RZvFwuehOluJiCws7VU9yOKcdTsSt060ZBI=; webframework-session-id=webframework; webframework-session-voucher=TLBHTSTQKEMFGGFP' \
		-O - 2> /dev/null
)

if [ $ENVELOPE -eq 0 ];then
	echo $json | python -m json.tool |
	awk '/"content"\s*:/ {gsub(/"content"\s*:/,"");gsub(/\\/,"");gsub(/"{/,"{");gsub(/",$/,"");print $0; exit}' |
	python -m json.tool
else
	echo $json | python -m json.tool
fi

echo
echo "=================================================================="

