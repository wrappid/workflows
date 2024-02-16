#!/bin/bash
# Script Author : Ananta Kumar Ghosh
# Contact       : ananta@anantakumarghosh.me
#               : antaghosh@protonmail.com
# Description   : This script downloads latest release from  github ($OWNER_NAME/$REPONAME)
#                 and extracts it.
OWNER_NAME=$1
REPONAME=$2
# DESTINATION="/usr/share/nginx"
create_folder_if_not_exists() {
    folder_path="$1"

    if [ ! -d "$folder_path" ]; then
        mkdir -p "$folder_path"
        echo "Folder created: $folder_path"
    fi
}

echo "$REPONAME-DEPLOY SCRIPT STARTED."
echo "========================="
echo "CHANGING WORKING DIRECTORY TO "$HOME"/temp TO DOWNLOAD LATEST RELEASE OF $REPONAME."
create_folder_if_not_exists "$HOME/temp"
echo "CLEANING UP PREVIOUS RELEASE ARTIFACT..."
echo $HOME/temp/
sudo rm -rf $HOME/temp/*
echo "========================="
cd $HOME/temp
echo "========================="
echo "CHANGED DIRECTORY. \nCURRENT WORKING DIRECTORY: "$PWD""
echo "========================="
echo "CLEANED PREVIOUS RELEASE ARTIFACT."
echo "SHOW ALL FILES:"
ls -al
echo "========================="
echo "STARTING DOWNLOAD OF $REPONAME ..."
gh release download --pattern "web*.zip" -R $OWNER_NAME/$REPONAME
echo "========================="
echo "DOWNLOADED FILES:"
ls -al
echo "========================="
echo "STARTING SETUP PROCESS OF NEW DOWNLOADED $REPONAME"
echo "========================="
echo "CURRENT WORKING DIRECTORY: " $PWD
echo "========================="
create_folder_if_not_exists "$HOME/$REPONAME"
echo "========================="
echo "SHOW ALL FILES:"
ls -al 
echo "CLEANING UP OLD SETUP OF $REPONAME ..."
echo $HOME/$REPONAME/
sudo rm -rf $HOME/$REPONAME/*
echo "========================="
echo "CLEANED OLD SETUP OF $REPONAME."
echo "========================="
echo "CHANGING WORKING DIRECTORY TO "$HOME"/$REPONAME"
cd $HOME/$REPONAME
echo "========================="
echo "SHOW ALL FILES:"
ls -al
echo "========================="
echo "COPYING NEW ARTIFICAT FROM "$HOME"/temp/ TO "$HOME"/$REPONAME..."
sudo cp $HOME/temp/*.zip $HOME/$REPONAME/
echo "========================="
echo "COPIED NEW ARTIFACT."
echo "SHOW ALL FILES:"
ls -al
echo "========================="
echo "UNZIPPING COPIED ARTIFACT ..."
sudo unzip web*.zip
#  > /dev/null
echo "========================="
echo "UNZIPPED COPIED ARTIFACT"
echo "SHOW ALL FILES:"
ls -al
# create_folder_if_not_exists "$DESTINATION/$REPONAME"
# sudo -u root cp -r $HOME/$REPONAME $DESTINATION/
echo "========================="
echo "$REPONAME-DEPLOY SCRIPT EXECUTION COMPLETED."
