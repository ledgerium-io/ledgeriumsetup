echo "Installing updates"
sudo apt-get update

echo "Installing packages to allow apt to use a repository over HTTPS"
sudo apt-get install -y \
apt-transport-https \
ca-certificates \
curl build-essential software-properties-common

echo "Installing Docker"
echo "Add Docker’s official GPG key"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - 

echo "Downloading docker"
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" 


echo "Installing Docker CE"

sudo apt-get update -y

echo "Installing latest version of docker ce"
sudo apt-get install -y docker-ce

echo "Testing docker"
sudo docker run hello-world 

echo "Add USER to docker group"
sudo groupadd docker
sudo usermod -aG docker $USER

echo "Installing docker compose"
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose &&
sudo chmod +x /usr/local/bin/docker-compose 

echo "Installing NodeJS"
sudo apt-get update -y && 
sudo apt-get -y upgrade &&
curl -sL https://deb.nodesource.com/setup_8.x -o nodesource_setup.sh &&
sudo bash nodesource_setup.sh &&
sudo apt-get install -y nodejs &&
rm nodesource_setup.sh

echo "Create docker network"
sudo docker network create -d bridge --subnet 172.19.240.0/24 --gateway 172.19.240.1 test_net
