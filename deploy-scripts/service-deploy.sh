#!/bin/bash
# Script Author : Ananta Kumar Ghosh
# Contact       : ananta@anantakumarghosh.me
#               : antaghosh@protonmail.com
# Description   : This script downloads latest release from  github ($OWNER_NAME/$REPONAME),
#                 extracts it and restarts pm2 service called - WrappidService

PROJECT_DEPLOYMENT_PATH=$1
OWNER_NAME=$2
REPONAME=$3

create_folder_if_not_exists() {
    folder_path="$1"

    if [ ! -d "$folder_path" ]; then
        mkdir -p "$folder_path"
        echo "Folder created: $folder_path"
    fi
}

echo "$REPONAME-DEPLOY SCRIPT STARTED."
echo "========================="
echo "CHANGING WORKING DIRECTORY TO $PROJECT_DEPLOYMENT_PATH/temp TO DOWNLOAD LATEST RELEASE OF $REPONAME."
create_folder_if_not_exists "$PROJECT_DEPLOYMENT_PATH/temp"
echo "CLEANING UP PREVIOUS RELEASE ARTIFACT..."
echo "$PROJECT_DEPLOYMENT_PATH/temp/"
sudo rm -rf "$PROJECT_DEPLOYMENT_PATH"/temp/service*.zip
echo "========================="
cd "$PROJECT_DEPLOYMENT_PATH/temp" || exit
echo "========================="
echo "CHANGED DIRECTORY. \nCURRENT WORKING DIRECTORY: ""$PWD"""
echo "========================="
echo "CLEANED PREVIOUS RELEASE ARTIFACT."
echo "SHOW ALL FILES:"
ls -al
echo "========================="
echo "STARTING DOWNLOAD OF $REPONAME ..."
gh release download --pattern "service*.zip" -R $OWNER_NAME/$REPONAME
echo "========================="
echo "DOWNLOADED FILES:"
ls -al
echo "========================="
echo "STARTING SETUP PROCESS OF NEW DOWNLOADED $REPONAME"
echo "========================="
echo "CURRENT WORKING DIRECTORY: " $PWD
echo "========================="
create_folder_if_not_exists "$PROJECT_DEPLOYMENT_PATH"/"$REPONAME"
echo "========================="
echo "SHOW ALL FILES:"
ls -al 
echo "CLEANING UP OLD SETUP OF $REPONAME ..."
echo "$PROJECT_DEPLOYMENT_PATH"/"$REPONAME"/
sudo rm -rf "$PROJECT_DEPLOYMENT_PATH"/"$REPONAME"/*
echo "========================="
echo "CLEANED OLD SETUP OF $REPONAME."
echo "========================="
echo CHANGING WORKING DIRECTORY TO "$PROJECT_DEPLOYMENT_PATH"/"$REPONAME"
cd "$PROJECT_DEPLOYMENT_PATH"/"$REPONAME" || exit
echo "========================="
echo "SHOW ALL FILES:"
ls -al
echo "========================="
echo "COPYING NEW ARTIFICAT FROM ""$PROJECT_DEPLOYMENT_PATH""/temp/ TO ""$PROJECT_DEPLOYMENT_PATH""/$REPONAME..."
sudo cp "$PROJECT_DEPLOYMENT_PATH"/temp/service*.zip "$PROJECT_DEPLOYMENT_PATH"/"$REPONAME"/
echo "========================="
echo "COPIED NEW ARTIFACT."
echo "SHOW ALL FILES:"
ls -al
echo "========================="
echo "UNZIPPING COPIED ARTIFACT ..."
unzip service*.zip > /dev/null
echo "========================="
echo "UNZIPPED COPIED ARTIFACT"
echo "SHOW ALL FILES:"
ls -al
echo "========================="
echo "RESTARTING PM2 $REPONAME ..."
pm2 restart $REPONAME
echo "========================="
echo "RESTARTED $REPONAME."
echo "$REPONAME-DEPLOY SCRIPT EXECUTION COMPLETED."
