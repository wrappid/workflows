#!/bin/bash

## INPUT ARG 1 - ENV_VARIABLE_NAME , EXAMPLE - REPOSITORY_NAME
## INPUT ARG 2 - VALUE_TO_SET , EXAMPLE - v1.0.0 | Fail

# Define the variable name and its new value
VARIABLE_NAME="$1"
NEW_VALUE="$2"
# Check if the variable already exists in the environment
if [ -z "${!VARIABLE_NAME}" ]; then
    echo "Variable $VARIABLE_NAME does not exist. Adding to ~/.bashrc..."
    echo "export $VARIABLE_NAME=\"$NEW_VALUE\"" >>~/.bashrc
else
    echo "Variable $VARIABLE_NAME exists. Modifying ~/.bashrc..."
    sed -i "s/^export $VARIABLE_NAME=.*$/export $VARIABLE_NAME=\"$NEW_VALUE\"/g" ~/.bashrc
fi

# Load the changes into the current environment
source ~/.bashrc

echo "Variable $VARIABLE_NAME is now set to: $NEW_VALUE"
