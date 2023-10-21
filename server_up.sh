#!/bin/bash
hardStart=$1

backend="git@github.com:ignitingMinds/bcrmBackend.git"
frontend="git@github.com:ignitingMinds/quickquoteUI.git"
directory_name="bharat-crm"

if [ "$hardStart" = "true" ]; then
    echo "........HARD START........."
        
    if [ -d "$directory_name" ]; then
        rm -rf "$directory_name"
        echo "Directory $directory_name has been removed."
    else
        echo "Directory $directory_name does not exist."
    fi

    echo "Creating directory $directory_name"
    mkdir $directory_name
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

    # copying yaml file
    cp ../docker-compose.yml .

    # loading the configurations 
    echo "adding configurations"
    cp ../../configs/config.yaml bcrmBackend/src/config/
    cp ../../configs/.env quickquoteUI/

    # down
    echo "down previous compose"
    sudo docker-compose down

    echo "removing old images"
    sudo docker rmi bharat-crm_crm-backend
    sudo docker rmi bharat-crm_crm-frontend
else
    cd $directory_name
    echo ".......SOFT START.........."
fi

# code related to the docker compoes up
# creating image and deploying
echo "running docker-compose"
sudo docker-compose up -d 