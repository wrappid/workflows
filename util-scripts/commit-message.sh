#!/bin/bash

VERSION=$1

# Create the file with the provided release message
echo -e "chore(tag-release): $VERSION\n\ncreate new tag\n\nref: NA" >commit-message.txt
