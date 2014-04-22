#! /usr/bin/env bash

chatservers () {
	ps aux | awk '
		/awk|grepid/ {next}
		/ferite.*generic_chatserver/ {print $2}
	'
}

chatservers | xargs kill -9
