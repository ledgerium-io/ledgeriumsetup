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

IP=$(curl -s https://api.ipify.org)
echo $IP

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
data.domainName = "$(hostname)";
data.externalIPAddress = "$IP"

//Output data
fs.writeFileSync('./initialparams.json',JSON.stringify(data))

EOF

mkdir -p output/tmp &&
mkdir -p output/fullnode &&
node index.js &&
cd output &&
docker-compose up -d


elif [ "$MODE" = "addon" ]; then
echo "+--------------------------------------------------------------------+"
echo "|***************** Executing script for '$MODE' mode ****************|"

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

cd ledgeriumtools &&
mkdir -p output/tmp &&
echo "$PWD"

node <<EOF
//Read data
var data = require('./initialparams.json');
var fs = require('fs');

var staticNodes = require('../ledgeriumnetwork/static-nodes.json');
var enode = staticNodes[0];
var externalIPAddress = (enode.split('@')[1]).split(':')[0];

//Manipulate data
data.mode = "$MODE";
data.nodeName = "$(hostname)";
data.domainName = "$(hostname)";
data.externalIPAddress = externalIPAddress;

//Output data
fs.writeFileSync('./initialparams.json',JSON.stringify(data))
EOF

node index.js && cp ../ledgeriumnetwork/* ./output/tmp &&
cd output &&
docker-compose up -d

else
echo "Invalid mode"
fi