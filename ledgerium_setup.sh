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

echo "Enter external IP address"
read -p 'External IP Address:' External_IPAddress

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
data.externalIPAddress = "$External_IPAddress"

//Output data
fs.writeFileSync('./initialparams.json',JSON.stringify(data))

EOF

mkdir -p output/tmp &&
node index.js &&
cd output &&
docker-compose up -d


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
data.externalIPAddress = "$External_IPAddress"

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
git pull -f https://github.com/ledgerium/ledgeriumnetwork master &&
cd ../

else

echo "|**************** Ledgerium network deosn't exist *******************|"
echo "|************ Cloning Ledgerium network from github *****************|"
echo "+--------------------------------------------------------------------+"

git clone https://github.com/ledgerium/ledgeriumnetwork

fi

cp ledgeriumnetwork/* ledgeriumtools/output/tmp &&
cd ledgeriumtools &&
mkdir -p output/tmp &&
node index.js &&
cd output &&
docker-compose up -d

else
echo "Invalid mode"
fi