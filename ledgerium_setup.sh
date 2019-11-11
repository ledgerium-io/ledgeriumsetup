#!/bin/bash
echo "Do you want to run cleanup script first?"
echo "Choosing 'yes' will stop any running containers and takes backup of ledgeriumtools"
read -p "(yes/no) : " CLEANUP

if [ $CLEANUP == "yes" ]; then
    echo "Running cleanup script"
    ./ledgerium_cleanup.sh
elif [ $CLEANUP == "no" ]; then
    echo "Running setup without cleanup"
else
    echo "Invalid input :: $CLEANUP"
fi

cd ../
DIRECTORY="$PWD/ledgeriumtools"

# Check if ledgeriumtools folder exists
    # If yes, go to ledgerium tools
    # Else, clone ledgerium tools repo
if [ -d "$DIRECTORY" ]; then

    echo "+-----------------------------------------------------------------------+"    
    echo "|***************** Ledgerium tools folder exists ***********************|"

    cd ledgeriumtools

    else 

    echo "+-----------------------------------------------------------------------+"
    echo "|**************** Ledgerium tools folder doesn't exist *****************|"
    echo "|***************** Cloning ledgerium tools from github *****************|"
    echo "+-----------------------------------------------------------------------+"

    git clone http://github.com/ledgerium-io/ledgeriumtools &&
    cd ledgeriumtools

    echo "+-----------------------------------------------------------------------+" 
    echo "|********************** Installing node modules ************************|" 
    echo "+-----------------------------------------------------------------------+"  

    npm install 

fi

echo "|***************** Running ledgerium tools application *****************|"
echo "+----------------------------------------------------------------------+"

# Enter the type of node setup
echo "Select the type of node setup - full/blockproducer ('0' for 'blockproducer' and '1' for 'full')"
read -p 'MODE:' MODE

IP=$(curl -s https://api.ipify.org)

if [ $MODE = "0" ]; then
    echo "+--------------------------------------------------------------------+"
    echo "|***************** Executing script for blockproducer mode ****************|"

    # Enter the folder name to pick network files
    echo "Enter the testnet - toorak/flinders ('0' for 'toorak' and '1' for 'flinders')"
    read -p 'TESTNET:' TESTNET

    FLAG=false;
    NETWORK="TOORAK"
    if [ $TESTNET = "0" ]; then
        FLAG=false
        NETWORK="toorak"
    else
        FLAG=true
        NETWORK="flinders"
    fi

    cd ../
    LED_NETWORK="$PWD/ledgeriumnetwork"

    if [ -d "$LED_NETWORK" ]; then
        cd ledgeriumnetwork 
    else
        mkdir ledgeriumnetwork
        cd ledgeriumnetwork
    fi
    
    curl -LJO https://raw.githubusercontent.com/ledgerium-io/ledgeriumnetwork/master/$NETWORK/genesis.json
    curl -LJO https://raw.githubusercontent.com/ledgerium-io/ledgeriumnetwork/master/$NETWORK/static-nodes.json

    cd ../ledgeriumtools &&
    mkdir -p output/tmp &&
    echo "$PWD"

    node <<EOF
        //Read data
        var data = require('./initialparams.json');
        var fs = require('fs');

        var staticNodes = require('../ledgeriumnetwork/static-nodes.json');
        var genesisInfo = require('../ledgeriumnetwork/genesis.json');
        var enode = staticNodes[0];
        var externalIPAddress = (enode.split('@')[1]).split(':')[0];
        var networkId = genesisInfo.config.chainId;

        //Manipulate data
        data.mode = "blockproducer";
        data.distributed = $FLAG;
        data.env = "devnet";
        data.network = "$NETWORK";
        data.nodeName = "$(hostname)";
        data.domainName = "$(hostname)";
        data.externalIPAddress = externalIPAddress;
        data.networkId = networkId;

        //Output data
        fs.writeFileSync('./initialparams.json',JSON.stringify(data))
EOF
    node index.js && 
    cp ../ledgeriumnetwork/* ./output/tmp &&
    cd output &&
    docker-compose up -d
elif [ $MODE = "1" ]; then

    # Enter the type of node setup
    echo "Is this a local setup or distributed? ('0' for local and '1' for distributed)"
    read -p 'Setup:' SETUP

    if [ $SETUP = "1" ]; then

        echo "|***************** Executing script for distributed full mode ****************|"
        
        # Enter Network ID
        ok=0
        while [ $ok = 0 ]
        do
        echo "Enter Network ID"
        echo "Should be a 4 digit number. Ex: 2019"
        read -p 'Network ID:' NETWORKID
        if [[ ! $NETWORKID =~ ^[0-9]{4} ]]
        then
            echo Only numbers and 4 digits
        else
            if [[ ${#NETWORKID} -eq 4 ]]
                then
                ok=1
            else
                echo Length should be 4
            fi
            echo $id
        fi
        done
        
        node <<EOF

            //Read data
            var data = require('./initialparams.json');
            var fs = require('fs');

            //Manipulate data
            data.mode = "full";
            data.distributed = true;
            data.env = "devnet";
            data.network="flinders";
            data.nodeName = "$(hostname)";
            data.domainName = "$(hostname)";
            data.externalIPAddress = "$IP";
            data.networkId = ($NETWORKID == "")? "2018" : $NETWORKID; 

            //Output data
            fs.writeFileSync('./initialparams.json',JSON.stringify(data))

EOF

        # Distributed Setup

        mkdir -p output/tmp         &&
        mkdir -p output/fullnode    &&
        node index.js               &&
        cd output                   &&

        #Read static-nodes.json
        value=$(<tmp/static-nodes.json)
        
        # Convert 'value' to an array
        IFS=',()][' read -r -a array <<<$value

        for index in ${!array[@]}; 
        do
            echo "Remaining nodes will be run on remote servers"
            #Split with '@' and take second part
            A="$(echo ${array[$index]} | cut -d'@' -f2)"                                    
            #Split with ':' and take first part which is IP Address
            B="$(echo $A | cut -d':' -f1)"

            if [ $index = 0 ]; then
                # Skip 0th element of array
                echo "Skip 0th element of array"
            elif [ $index = 1 ]; then 
                echo "First node will be run in same host"
                cp fullnode/"docker-compose_$((index-1)).yml" docker-compose.yml
                docker-compose up -d
            else
                FOLDER=node_$((index-1))                                                        &&
                mkdir -p $FOLDER/tmp                                                            &&
                cp fullnode/".env$((index-1))" $FOLDER/.env                                                                 &&
                cp fullnode/"docker-compose_$((index-1)).yml" $FOLDER/docker-compose.yml     &&
                cp fullnode/tmp/"privatekeys$((index-1)).json" $FOLDER/tmp/privatekeys.json  &&
                cp tmp/nodesdetails.json tmp/genesis.json tmp/static-nodes.json $FOLDER/tmp                                            &&
                echo "*** Enter username for $B ***"                                            &&
                read -p 'Username:' username                                                    &&
                echo "*** Enter password to create folder structure ***"                        &&
                ssh $username@$B "cd ~/ledgerium/ && mkdir -p ledgeriumtools/output/tmp"        &&
                echo "*** Enter password to start copying files ***"                            &&
                scp -r $FOLDER/* $FOLDER/.env $username@$B:~/ledgerium/ledgeriumtools/output                 &&
                echo "*** Enter password to start bring up docker containers ***"                 
                ssh $username@$B "cd ~/ledgerium/ledgeriumtools/output && docker-compose up -d" 
            fi
        done
        echo "*** Removing files from fullnode ***"
        sudo rm -rf fullnode node_*
    elif [ $SETUP = "0" ]; then
        echo "|***************** Executing script for local full mode ****************|"
        # Enter Network ID
                # Enter Network ID
        ok=0
        while [ $ok = 0 ]
        do
        echo "Enter Network ID"
        echo "Should be a 4 digit number. Ex: 2019"
        read -p 'Network ID:' NETWORKID
        if [[ ! $NETWORKID =~ ^[0-9]{4} ]]
        then
            echo Only numbers and 4 digits
        else
            if [[ ${#NETWORKID} -eq 4 ]]
                then
                ok=1
            else
                echo Length should be 4
            fi
            echo $id
        fi
        done
        
        echo "+--------------------------------------------------------------------+"

        node <<EOF

        //Read data
        var data = require('./initialparams.json');
        var fs = require('fs');

        //Manipulate data
        data.mode = "full";
        data.distributed = false;
        data.env = "testnet";
        data.network="toorak";
        data.nodeName = "$(hostname)";
        data.domainName = "$(hostname)";
        data.externalIPAddress = "$IP";
        data.networkId = ($NETWORKID == "")? "2018" : $NETWORKID;

        //Output data
        fs.writeFileSync('./initialparams.json',JSON.stringify(data))

EOF

        # Full mode Setup 
        mkdir -p output/tmp &&
        mkdir -p output/fullnode &&
        node index.js &&
        cd output &&
        docker-compose up -d
    else 
    echo "Invalid setup value :: $SETUP"
    fi
else
        echo "Invalid mode :: $MODE"
fi
