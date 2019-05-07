cd ~/ledgerium/ledgeriumtools/output

echo $PWD
DIR=$1
echo $DIR
#DOP=( $(echo $(docker ps -a | grep ledgeriumcore | awk '{print $1}')) )

#COUNTER=0;
#for CID in "${DOP[@]}"; do
#       let COUNTER=COUNTER+1
#       echo $CID
#       docker cp $CID:/eth $DIR/eth$COUNTER
#       docker cp $CID:/priv $DIR/priv$COUNTER
#done
echo 'Stopping all containers'
docker-compose down

echo 'Moving datastore files'
mkdir -p $DIR/output
mv tessera-* $DIR/output/
mv validator-* $DIR/output/
#rm -rf tessera-*
#rm -rf validator-*

echo 'Starting all containers'
docker-compose up -d




