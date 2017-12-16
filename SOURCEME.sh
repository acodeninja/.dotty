#!/bin/sh

# Get the current directory
THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Load modules
for MODULE in `find $THIS_DIR/modules/* -type d`
do
  source $MODULE/init.sh
done
