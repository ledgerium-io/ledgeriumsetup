#!/bin/bash
cd ~/ledgerium/ledgeriumtools/output
echo "Current folder - $PWD"

if [ -z "$1" ]
  then
    echo "Backup folder is not supplied"
    exit 1
fi

DIR=$1
echo "Backup folder $DIR"

echo 'Stopping all containers'
docker-compose down

echo 'Moving datastore files'
mkdir -p $DIR/output
sudo mv -f tessera-* $DIR/output/
sudo mv -f validator-* $DIR/output/

echo 'Starting all containers'
docker-compose up -d