#!/bin/bash
export HOME=/home/$(whoami)

# set timezone
if [ -z "$TIMEZONE" ]; then
	export TIMEZONE='UTC'
fi
# set timezone
cat /usr/share/zoneinfo/$TIMEZONE > /etc/localtime
echo $TIMEZONE > /etc/timezone

# run user scripts
if [[ -d ${ENV_DIR}/files/.$(whoami) ]]; then
	chmod +x ${ENV_DIR}/files/.$(whoami)/*
	run-parts ${ENV_DIR}/files/.$(whoami)
fi
$SHELL