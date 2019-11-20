#!/bin/bash

# if [ -z "$1" ]
#   then
#     echo "Backup folder is not supplied"
#     exit 1
# fi

# Timestamp function
timestamp() {
  date +"%Y_%m_%d_%H_%M_%S"
}
DIR="ledgeriumtools_$(timestamp)"

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    
    #Get Linux distribution
    DIST=$(cat /proc/version)

    #Ubuntu or CentOS
    if 
    [[ $DIST == *"Ubuntu"* ]] ||
    [[ $DIST == *"centos"* ]]; then
        echo "OS: $DIST"

        docker rm $(docker stop $(docker ps -aq --filter name=output_))
        cd ..
        if [ ! -d ledgeriumtools ]; then
          echo "ledgeriumtools doesnot exist, nothing to backup"
          exit
        else 
          mv ledgeriumtools $DIR
          echo "Existing containers are stopped and ledgeriumtools folder is backed up with $DIR"
          exit
        fi
    else
        echo "Unknown linux distribution"
    fi

elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
        echo "OS: $OSTYPE"

        docker rm $(docker stop $(docker ps -aq --filter name=output_))
        cd ..
        if [ ! -d ledgeriumtools ]; then
          echo "ledgeriumtools doesnot exist, nothing to backup"
          exit
        else 
          mv ledgeriumtools $DIR
          echo "Existing containers are stopped and ledgeriumtools folder is backed up with $DIR"
          exit
        fi
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
