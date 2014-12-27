#!/bin/bash

if [ "$SECRET" == "false" ]; then
    SECRET=`btsync --generate-secret`
fi

HOSTNAME=`hostname`

set -i "s/MY_SERVER_1/$HOSTNAME/" /btsync/btsync.conf
sed -i "s/MY_SECRET_1/$SECRET/" /btsync/btsync.conf
echo "Starting btsync with secret: $SECRET"

/usr/local/bin/btsync --config /btsync/btsync.conf --nodaemon
