# ledgeriumsetup

Provides a shell script to deploy nodes in full/addon mode

## Install dependencies

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


## Run ledgerium tools
```
./ledgerium_setup.sh
```
This script prompts user for 2 parameters, type of mode (full/addon) and domain name, creates a docker-compose file and brings up the cointainers

## To install node_modules for $USER, follow the steps mentioned below

* mkdir ~/.npm-global

* npm config set prefix '~/.npm-global'

* export PATH="$HOME/.npm-global/bin:$PATH"  # ← put this line in .bashrc

* source ~/.bashrc  # if you only updated .bashrc

Note: This is not included in the script as it is a one time process.