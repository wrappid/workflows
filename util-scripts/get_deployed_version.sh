#!/bin/bash

# Define the variable name to check
VARIABLE_NAME=$1

# Define the input value
INPUT_VALUE=$2
source ~/.bashrc
# Check if the variable exists in the environment
if [ -z "${!VARIABLE_NAME}" ]; then
    echo "PROCEED"
    # Environment variable $VARIABLE_NAME does not exist. Proceeding...
else
    # Environment variable $VARIABLE_NAME exists.
    # Check if the value matches the input value
    if [ "${!VARIABLE_NAME}" = "$INPUT_VALUE" ]; then
        echo "FAIL"
        # Fail: Environment variable $VARIABLE_NAME has the same value as the input value.
    elif [ "${!VARIABLE_NAME}" = "FAIL" ]; then
        echo "PROCEED"
        # Proceed: Environment variable $VARIABLE_NAME has the value 'FAIL'.
    else
        echo "PROCEED"
        # Value of $VARIABLE_NAME is different from the input value and not 'FAIL'.
    fi
fi
