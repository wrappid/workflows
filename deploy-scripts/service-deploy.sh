#!/bin/bash
# Script Author : Ananta Kumar Ghosh
# Contact       : ananta@anantakumarghosh.me
#               : antaghosh@protonmail.com
# Description   : This script downloads latest release from  github ($OWNER_NAME/$REPONAME),
#                 extracts it and restarts pm2 service called - WrappidService
OWNER_NAME=$1
REPONAME=$2

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
cd $HOME/temp
echo "========================="
echo "CHANGED DIRECTORY. \nCURRENT WORKING DIRECTORY: "$PWD""
echo "========================="
echo "CLEANING UP PREVIOUS RELEASE ARTIFACT..."
echo $PWD
rm -rf service*.zip
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
echo "CHANGING WORKING DIRECTORY TO "$HOME"/$REPONAME"
create_folder_if_not_exists "$HOME/$REPONAME"
cd $HOME/$REPONAME
echo "========================="
echo "SHOW ALL FILES:"
ls -al
echo "========================="
echo "CLEANING UP OLD SETUP OF $REPONAME ..."
echo $PWD
rm -rf *
echo "========================="
echo "CLEANED OLD SETUP OF $REPONAME."
echo "SHOW ALL FILES:"
ls -al
echo "========================="
echo "COPYING NEW ARTIFICAT FROM "$HOME"/temp/ TO "$HOME"/$REPONAME..."
cp $HOME/temp/service*.zip $HOME/$REPONAME/
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
