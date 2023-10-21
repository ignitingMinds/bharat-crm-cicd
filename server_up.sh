#!/bin/bash

backend="git@github.com:ignitingMinds/bcrmBackend.git"
frontend="git@github.com:ignitingMinds/quickquoteUI.git"

directory_name="bharat-crm"

if [ -d "$directory_name" ]; then
    rm -rf "$directory_name"
    echo "Directory $directory_name has been removed."
else
    echo "Directory $directory_name does not exist."
fi

echo "Creating directory $directory_name"
mkdir $directory_name
#sudo chown -R $USER ./$directory_name
cd $directory_name
pwd

echo "cloning backend"
git clone $backend
cd bcrmBackend
git checkout QA
cd ..


echo "cloning frontend"
git clone $frontend
cd quickquoteUI
git checkout UAT
cd ..

# echo "cloning docker compose file"
# git clone $docker_compose
# mv bharat-crm-compose/docker-compose.yml
# rm -rf bharat-crm-compose
cp ../docker-compose.yml .

# loading the configurations 
echo "adding configurations"
cp ../configs/config.yaml bcrmBackend/src/config/
cp ../configs/.env quickquoteUI/

# down
echo "down previous compose"
sudo docker-compose down

echo "removing old images"
sudo docker rmi bharat-crm_crm-backend
sudo docker rmi bharat-crm_crm-frontend

# code related to the docker compoes up
# creating image and deploying
echo "running docker-compose"
sudo docker-compose up -d 