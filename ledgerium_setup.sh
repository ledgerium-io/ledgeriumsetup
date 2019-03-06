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

git clone http://github.com/ledgerium/ledgeriumtools &&
cd ledgeriumtools &&

echo "+-----------------------------------------------------------------------+"
echo "|********************** Installing node modules ************************|"
echo "+-----------------------------------------------------------------------+" 

npm install 

fi

echo "|***************** Running ledgerium tools application *****************|"
echo "+----------------------------------------------------------------------+"

# Enter the type of node setup
echo "Enter the type of node setup - full/addon"
read -p 'MODE:' MODE

echo "Enter domain name"
read -p 'Domain Name:' Domain_Name

if [ "$MODE" = "full" ]; then

echo "+--------------------------------------------------------------------+"
echo "|***************** Executing script for '$MODE' mode ****************|"

node <<EOF

//Read data
var data = require('./initialparams.json');
var fs = require('fs');

//Manipulate data
data.mode = "$MODE";
data.nodeName = "$(hostname)";
data.domainName = "$Domain_Name";

//Output data
fs.writeFileSync('./initialparams.json',JSON.stringify(data))

EOF

node index.js &&
cd ../ &&
LED_NETWORK="$PWD/ledgeriumnetwork/.git"

#Check if ledgerium network is already a git repo
    # If yes, Commit and push
    # Else, init git, commit and push
if [ -d "$LED_NETWORK" ]; then 
echo "|****************** Ledgerium network folder exists *****************|"
echo "|******** Commit and push files to ledgerium network github *********|"
echo "+--------------------------------------------------------------------+"
cd ledgeriumnetwork &&
git add . &&
git commit -m "Updates" &&
git push -f https://github.com/ledgerium/ledgeriumnetwork.git feat/LB-95 &&
cd ../ledgeriumtools/output &&
docker-compose up -d &&
echo "+--------------------------------------------------------------------+"
echo "|***************** Docker Containers for nodes are up ***************|"
echo "+--------------------------------------------------------------------+"

else
echo "|**************** Ledgerium network folder doesn't exist ************|"
echo "|** Initialise, commit and push files to ledgerium network github ***|"
echo "+--------------------------------------------------------------------+"
cd ledgeriumnetwork &&
git init &&
git checkout -b feat/LB-95 &&
git add . &&
git commit -m "Updates" &&
git push -f https://github.com/ledgerium/ledgeriumnetwork.git feat/LB-95 &&
cd ../ledgeriumtools/output &&
docker-compose up -d &&
echo "+--------------------------------------------------------------------+"
echo "|***************** Docker Containers for nodes are up ***************|"
echo "+--------------------------------------------------------------------+"

fi

elif [ "$MODE" = "addon" ]; then
echo "+--------------------------------------------------------------------+"
echo "|***************** Executing script for '$MODE' mode ****************|"
node <<EOF
//Read data
var data = require('./initialparams.json');
var fs = require('fs');

//Manipulate data
data.mode = "$MODE";
data.nodeName = "$(hostname)";
data.domainName = "$Domain_Name";

//Output data
fs.writeFileSync('./initialparams.json',JSON.stringify(data))
EOF

cd ../
LED_NETWORK="$PWD/ledgeriumnetwork"

if [ -d "$LED_NETWORK" ]; then 

echo "|******************** Ledgerium network exists **********************|"
echo "|************ Pulling Ledgerium network from github *****************|"
echo "+--------------------------------------------------------------------+"

cd ledgeriumnetwork &&
git stash &&
git pull -f https://github.com/ledgerium/ledgeriumnetwork feat/LB-95 &&
cd ../

else

echo "|**************** Ledgerium network deosn't exist *******************|"
echo "|************ Cloning Ledgerium network from github *****************|"
echo "+--------------------------------------------------------------------+"

git clone -b feat/LB-95 https://github.com/ledgerium/ledgeriumnetwork

fi

cp ledgeriumnetwork/* ledgeriumtools/output/tmp &&
cd ledgeriumtools &&

node index.js

else
echo "Invalid mode"
fi