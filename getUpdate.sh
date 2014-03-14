#! /bin/bash

HOST=localhost:9090

if [ "$1" != "" ];then
	HOST=$1
fi

echo "[Response]========================================================"
wget "http://${HOST}/Cention/chat/harmony/-/MCAM/GlobalChat.getUpdate" \
	--post-data='&areas=1%2C3%2C2%2C4&users=2' \
	--no-cookie \
	--header 'Cookie: cention-suiteWFUserID=2; cention-suiteWFPassword=kW83un60RZvFwuehOluJiCws7VU9yOKcdTsSt060ZBI=; webframework-session-id=webframework; webframework-session-voucher=TLBHTSTQKEMFGGFP' \
	-O - 2> /dev/null |
	python -m json.tool |
	awk '/"content"\s*:/ {gsub(/"content"\s*:/,"");gsub(/\\/,"");gsub(/"{/,"{");gsub(/",$/,"");print $0; exit}' | python -m json.tool
echo
echo "=================================================================="

