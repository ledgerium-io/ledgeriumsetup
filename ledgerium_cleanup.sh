#!/bin/bash

if [ -z "$1" ]
  then
    echo "Backup folder is not supplied"
    exit 1
fi

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    
    #Get Linux distribution
    DIST=$(cat /proc/version)

    #Ubuntu or CentOS
    if 
    [[ $DIST == *"Ubuntu"* ]] ||
    [[ $DIST == *"centos"* ]]; then
        echo "OS: $DIST"

        cd ../ledgeriumtools/output || exit
        echo "Current folder - $PWD"

        # Timestamp function
        timestamp() {
          date +"%Y_%m_%d-%H:%M:%S"
        }

        DIR=$1
        echo "Backup folder $DIR"

        echo 'Stopping all containers'
        docker-compose down

        echo 'Moving datastore files'
        folder="$(timestamp)"_output
        mkdir -p "$DIR"/"$folder"
        sudo mv -f tessera-* "$DIR"/"$folder"
        sudo mv -f validator-* "$DIR"/"$folder"

        echo 'Starting all containers'
        docker-compose up -d
    
    else
        echo "Unknown linux distribution"
    fi

elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
        echo "OS: $OSTYPE"
elif [[ "$OSTYPE" == "cygwin" ]]; then
        # POSIX compatibility layer and Linux environment emulation for Windows
        echo "OS: $OSTYPE"
elif [[ "$OSTYPE" == "msys" ]]; then
        # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
        echo "OS: $OSTYPE"
elif [[ "$OSTYPE" == "win32" ]]; then
        echo "OS: $OSTYPE"
elif [[ "$OSTYPE" == "freebsd"* ]]; then
        # ...
        echo "OS: $OSTYPE"
else
        # Unknown.
        echo "Unknown OS: $OSTYPE"
fi
