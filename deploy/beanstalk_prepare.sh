#!/bin/bash

set -e           # fail the script if any line fails
set -x           # print all executed commands
set -o pipefail  # fail if any command within a series of piped commands fails, instead of just the rightmost

echo "APPLICATION_VERSION_LABEL=${APPLICATION_VERSION_LABEL}"

# Create zipfile
zip -r ${APPLICATION_VERSION_LABEL}.zip * .ebextensions
