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
The script will check for existing ledgerium setup. If exists, it asks if a clean up is required or not. Clean up will stop and remove all running containers, backup existing ledgeriumtools folder and starts a fresh setup. This may end up losing ledgerium accounts on your node and other data and additionally, it might take a while before the new node syncs up with Ledgerium Blockchain fully. The new node may not be able to write transactions during this period

Later, it will ask for further parameters

```
* Type of node setup : Enter '0' for blockproducer, '1' for full
* Type of testnet : '0' for 'toorak' or '1' for 'flinders' 
* IP Address: If IP address is different from blockproducer server address, provide input. Else hit 'Enter'
* Domain Name : If you have a domain name, provide the input. Else hit 'Enter' to use IP address as domain name
* Validator Name : Use any name of your choice. This will be helpful in identifying your node in blockexplorer UI.
* Enter mnemonics and password
```
After providing all the inputs, ledgeriumtools creates a docker-compose.yml file in loedgeriumtools/output folder. Ledgerum setup script brings up the node using this yml file.

## Cleanup Ledgerium Node
```
./ledgerium_cleanup.sh
```
This script takes back up of folder ledgeriumtools/output to `ledgeriumtools_(timestamp)`  and relaunch all the docker containers to restart the node afresh. This script should only be used if ledgerium node needs to be resetup again. It is useful when there are issues in the node synching.
