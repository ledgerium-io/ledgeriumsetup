#!/bin/bash

echo "Installing updates"
if [[ "$OSTYPE" == "linux-gnu" ]]; then
     #Get Linux distribution
    DIST=$(cat /proc/version)
    #Ubuntu
    if [[ $DIST == *"Ubuntu"* ]]; then
            echo "OS: $DIST"

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
            curl -sL https://deb.nodesource.com/setup_12.x -o nodesource_setup.sh &&
            sudo bash nodesource_setup.sh &&
            sudo apt-get install -y nodejs &&
            rm nodesource_setup.sh

            echo "Create docker network"
            sudo docker network create -d bridge --subnet 172.19.240.0/24 --gateway 172.19.240.1 test_net
            
    #CentOS
    elif [[ $DIST == *"centos"* ]]; then        
            echo "OS: $DIST"
            
            echo "Installing updates"
            sudo yum update -y

            sudo yum install -y yum-utils \
            device-mapper-persistent-data \
            lvm2

            echo "Install git"
            sudo yum install git -y

            echo "Installing Docker"
            echo "Downloading docker"
            sudo yum-config-manager \
                --add-repo \
                https://download.docker.com/linux/centos/docker-ce.repo


            echo "Installing Docker CE"
            sudo yum install docker-ce docker-ce-cli containerd.io -y
            sudo systemctl start docker

            echo "Testing docker"
            sudo docker run hello-world 

            echo "Add USER to docker group"
            sudo groupadd docker
            sudo usermod -aG docker $USER

            echo "Installing docker compose"
            sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
            sudo mv /usr/local/bin/docker-compose /usr/bin/docker-compose
            sudo chmod +x /usr/bin/docker-compose 

            echo "Installing NodeJS"
            sudo yum install -y gcc-c++ make
            sudo curl -sL https://rpm.nodesource.com/setup_10.x | sudo -E bash -
            sudo yum install nodejs -y

            echo "Create docker network"
            sudo docker network create -d bridge --subnet 172.19.240.0/24 --gateway 172.19.240.1 test_net

    else
        echo "Unknown linux distribution"
    fi        

elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
        echo "OS: $OSTYPE"
        echo "OS: $DIST"
            
            echo "Install git"
            sudo brew install git

            echo "Testing docker"
            sudo docker run hello-world 

            echo "Installing NodeJS"
            brew install node

            echo "Create docker network"
            sudo docker network create -d bridge --subnet 172.19.240.0/24 --gateway 172.19.240.1 test_net

elif [[ "$OSTYPE" == "cygwin" ]]; then
        # POSIX compatibility layer and Linux environment emulation for Windows
        echo "OS: $OSTYPE"
elif [[ "$OSTYPE" == "msys" ]]; then
        # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
        echo "OS: $OSTYPE"
elif [[ "$OSTYPE" == "win32" ]]; then
        echo "OS: $OSTYPE"
elif [[ "$OSTYPE" == "freebsd"* ]]; then
        # ...
        echo "OS: $OSTYPE"
else
        # Unknown.
        echo "Unknown OS: $OSTYPE"
fi