# ledgeriumsetup

Provides a shell script to deploy nodes in full/addon mode

## To install node_modules for $USER, follow the steps mentioned below

* mkdir ~/.npm-global

* npm config set prefix '~/.npm-global'

* export PATH="$HOME/.npm-global/bin:$PATH"  # ← put this line in .bashrc

* source ~/.bashrc  # if you only updated .bashrc

Note: This is not included in the script as it is a one time process.