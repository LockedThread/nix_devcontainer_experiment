#!/bin/bash

# This script is used to overwrite the check-requirements.sh script in the cursor-server
# It is used to make the cursor-server work with the patched node binary

set -e

CURSOR_HASH=$1

# Get the path to the cursor-server
CURSOR_SERVER_PATH="/root/.cursor-server/bin/${CURSOR_HASH}"

# Get the path to the check-requirements.sh script
CHECK_REQUIREMENTS_SCRIPT="${CURSOR_SERVER_PATH}/bin/helpers/check-requirements.sh"

# Overwrite the check-requirements.sh script
mv ./check-requirements.sh ${CHECK_REQUIREMENTS_SCRIPT}

# Make the script executable
chmod +x ${CHECK_REQUIREMENTS_SCRIPT}

