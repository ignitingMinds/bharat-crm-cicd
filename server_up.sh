#!/bin/bash
hardStart=$1
service=$2
sshAgent=$3

echo loading certificates
cp -r ../httpscreds/ /nginx/

if ["$sshAgent" = "y"]; then
    echo adding the ssh-agent
    eval "$(ssh-agent -s)"
    ssh-add ~/sshkey
fi

echo "hardStart : " $hardStart
echo "service   : "$service

backend="git@github.com:ignitingMinds/bcrmBackend.git"
frontend="git@github.com:ignitingMinds/quickquoteUI.git"
directory_name="bharat-crm"

flag="true"

# --------------------------------------------------------------------
if [ "$hardStart" = "true" ]; then
    echo "........HARD START........."
else
    cd $directory_name
    echo ".......SOFT START.........."
fi
# --------------------------------------------------------------------


# --------------------------------------------------------------------
if [ -d "$directory_name" ]; then
    flag="false"    
else
    echo "Creating directory $directory_name"
    mkdir $directory_name
fi
# --------------------------------------------------------------------

# --------------------------------------------------------------------
cd $directory_name
echo copying docker compose file
cp ../docker-compose.yml .

# down
echo "down previous compose"
sudo docker-compose down
# --------------------------------------------------------------------


# ---------------------------BACKEND------------------------------------
if [ "$hardStart" = "true" ] && { [ "$service" -eq 3 ] || [ "$service" -eq 1 ]; }; then 
    if [ "$flag" = "true" ]; then
        echo "cloning backend"
        git clone $backend
        cd bcrmBackend
        git checkout QA
        cd ..
    else
        echo "running git pull"
        cd bcrmBackend
        git pull 
        cd ..
    fi

    echo loading the backend configurations 
    cp ../../configs/config.yaml bcrmBackend/src/config/
  
    echo "removing old backend images"
    sudo docker rmi bharat-crm_crm-backend
fi
# --------------------------------------------------------------------

# ---------------------------FRONTEND---------------------------------
if [ "$hardStart" = "true" ] && { [ "$service" -eq 3 ] || [ "$service" -eq 2 ]; }; then 
    if [ "$flag" = "true" ]; then
        echo "cloning frontend"
        git clone $frontend
        cd quickquoteUI
        git checkout UAT
        cd ..
    else
        echo "running git pull"
        cd quickquoteUI
        git pull 
        cd ..
    fi

    # loading the configurations 
    echo loading the frontend configurations 
    cp ../../configs/.env quickquoteUI/

    echo "removing old frontend images"
    sudo docker rmi bharat-crm_crm-frontend
fi
# --------------------------------------------------------------------

# creating image and deploying
echo "running docker-compose up"
sudo docker-compose up -d

# remove the dirty images
sudo docker rmi $(sudo docker images|grep "<none>")