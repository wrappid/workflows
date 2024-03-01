#!/bin/bash
## INPUT ARG 1 - repository_name
## OUTPUT - REPOSITORY_NAME_VERSION

# Define the original string
original_string=$1

# Replace any characters other than numbers and alphabets with a single underscore
modified_string=$(echo "$original_string" | tr -cs '[:alnum:]' '_')

# Convert to uppercase and append VERSION
modified_string=$(echo "$modified_string" | tr '[:lower:]' '[:upper:]')VERSION

echo "$modified_string"