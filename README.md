# ledgeriumsetup

Provides a shell script to deploy nodes in full/blockproducer mode

## Install Dependencies

```
bash ./install_dependencies.sh
```
This script does the following:
* Checks OS version (Ubuntu/centos)
* Install prerequisite softwares (Docker and NodeJS) to run ledgerium tools.
* Add $USER to docker group, to avoid using sudo before docker commands
* Creates a docker network

Note : 

To update docker group, log out and log back in so that your group membership is re-evaluated.

* If testing on a virtual machine, it may be necessary to restart the virtual machine for changes to take effect.

* On a desktop Linux environment such as X Windows, log out of your session completely and then log back in.


## Launch Ledgerium Node
```
./ledgerium_setup.sh
```

Note: If you are running this setup for the first time, make sure to run `bash ./install_dependencies.sh` before running setup script.

The script will check for existing ledgerium setup. If exists, it asks if a clean up is required or not. Clean up will stop and remove all running containers, backup existing ledgeriumtools folder and starts a fresh setup. This may end up losing ledgerium accounts on your node and other data and additionally, it might take a while before the new node syncs up with Ledgerium Blockchain fully. The new node may not be able to write transactions during this period

Later, it will ask for further parameters to choose among different types of node setup mentioned below.

### Full and non-distributed setup
This setup creates a network of required number of nodes, all running on same machine

Required inputs from user:
1. Type of node setup (Enter '0' for blockproducer, '1' for full) - Should be `1` for this setup
2. Type of testnet ('0' for 'toorak' or '1' for 'flinders') - Should be `0` for this setup
3. Number of nodes
4. Mnemonics and password for each node

### Full and distributed setup
This setup creates a network of required number of nodes, where hostnode runs on the same machine where script is running and other nodes each running on different machine.

Required inputs from user:
1. Type of node setup (Enter '0' for blockproducer, '1' for full) - Should be `1` for this setup
2. Type of testnet ('0' for 'toorak' or '1' for 'flinders') - Should be `1` for this setup
3. Number of nodes
4. IP address, domain name, validator name, mnemonic and password for each node

Note: This setup creates docker-compose.yml files in in each machine. So, user should be aware of usernames and passwords of other machines before running this setup.

### Blockproducer setup
This setup creates a blockproducer node and connects to toorak/flinders network

Required inputs from user:
1. Type of node setup (Enter '0' for blockproducer, '1' for full) - Should be `0` for this setup
2. Type of testnet ('0' for 'toorak' or '1' for 'flinders') - Can be `0` or `1` based on the network to connect to.
3. IP address, domain name, validator name, mnemonic and password for each node

After providing all the inputs, ledgeriumtools creates a docker-compose.yml file in ledgeriumtools/output folder. Ledgerium setup script brings up the node using this yml file.

## Cleanup Ledgerium Node
```
./ledgerium_cleanup.sh
```
This script takes back up of folder ledgeriumtools/output to `ledgeriumtools_(timestamp)`  and remove all the docker containers. This script should only be used if ledgerium node needs to be resetup again. It is useful when there are issues in the node synching.