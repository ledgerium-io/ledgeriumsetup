# ledgeriumsetup

Provides a shell script to deploy nodes in full/addon mode

## Install Dependencies

```
./install_dependencies.sh
```
This script does the following:
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
This script prompts user for 2 parameters, type of mode (full/addon) and domain name, creates a docker-compose file and brings up the cointainers

## Cleanup Ledgerium Node
```
./ledgerium_cleanup.sh <backup folder path>
```
This script takes back up of folder ledgeriumtools/output to the supplied **backup path**  and relaunch all the docker containers to restart the node afresh. This script should only be used if ledgerium node needs to be resetup again. It is useful when there are issues in the node synching.
