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
          echo "Ledgerium tools doesnot exist, nothing to clean up"
          exit
        fi

        cd ledgeriumtools || exit
        echo "Current folder - $PWD"
        
        if [ ! -d $PWD/output ]; then
          echo "output directory doesnot exist"
          echo "Moving ledgeriumtools to $DIR"
          cd ..
          mv ledgeriumtools $DIR
        else
          echo "Output directory exists, checking for YML file"
          cd output

          if [ ! -f "docker-compose.yml" ]; then 
            echo "YML file doesnot exist"
            echo "Moving ledgeriumtools to $DIR"
            cd ../..
            mv ledgeriumtools $DIR
          else
            echo "YML file exists"

            echo 'Stopping all containers'
            docker-compose down

            cd ../..
            mv ledgeriumtools $DIR
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
          echo "Ledgerium tools doesnot exist, nothing to clean up"
          exit
        fi
        cd ledgeriumtools || exit
        echo "Current folder - $PWD"
        
        if [ ! -d $PWD/output ]; then
          echo "output directory doesnot exist"
          echo "Moving ledgeriumtools to $DIR"
          cd ..
          mv ledgeriumtools $DIR
        else
          echo "Output directory exists, checking for YML file"
          cd output

          if [ ! -f "docker-compose.yml" ]; then 
            echo "YML file doesnot exist"
            echo "Moving ledgeriumtools to $DIR"
            cd ../..
            mv ledgeriumtools $DIR
          else
            echo "YML file exists"

            echo 'Stopping all containers'
            docker-compose down

            cd ../..
            mv ledgeriumtools $DIR
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
