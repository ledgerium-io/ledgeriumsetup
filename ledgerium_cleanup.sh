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

        cd ..
        if [ ! -d ledgeriumtools ]; then
          echo "ledgerium ools doesnot exist, nothing to clean up"
          exit
        fi

        cd ledgeriumtools || exit
        echo "Current folder - $PWD"
        
        if [ ! -d $PWD/output ]; then
          echo "ledgeriumtools backed up with $DIR"
          cd ..
          mv ledgeriumtools $DIR
        else
          cd output
          if [ ! -f "docker-compose.yml" ]; then 
            cd ../..
            mv ledgeriumtools $DIR
            echo "No running containers found, ledgeriumtools folder is backed up with $DIR"
          else
            docker-compose down
            cd ../..
            mv ledgeriumtools $DIR
            echo "Existing containers are stopped and the existing ledgeriumtools folder is backed up with $DIR"
          fi
        fi
    else
        echo "Unknown linux distribution"
    fi

elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
        echo "OS: $OSTYPE"

        cd ..
        if [ ! -d ledgeriumtools ]; then
          echo "ledgeriumtools doesnot exist, nothing to clean up"
          exit
        fi
        cd ledgeriumtools || exit
        
        if [ ! -d $PWD/output ]; then
          cd ..
          mv ledgeriumtools $DIR
          echo "ledgeriumtools backed up with $DIR"
        else
          cd output
          if [ ! -f "docker-compose.yml" ]; then 
            echo "No running containers found, ledgeriumtools folder is backed up with $DIR"
            cd ../..
            mv ledgeriumtools $DIR
          else
            docker-compose down
            cd ../..
            mv ledgeriumtools $DIR
            echo "Existing containers are stopped and the existing ledgeriumtools folder is backed up with $DIR"
          fi
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
