#!/bin/bash

# By default our configuration is "default".
SET_CONFIG=default

# By default our server address is empty.
# If this is still empty after parsing arguments,
# we keep the original value unchanged in common.sh.
SET_SERVER=


# Parse the arguments.
# Curretnly we only adopt --config= and --server= options.
# The ${ARG#*=} means we would like to delete shortest match
# of "*=" substring from front of the original ${ARG} string.
# e.g. Assume ${ARG} is "--server=10.60.0.129", then ${ARG#*=} is "10.60.0.129".
# See "Substring Removal" section in http://tldp.org/LDP/abs/html/string-manipulation.html
for ARG in "$@"
do
  case ${ARG} in
    --config=*)
      SET_CONFIG="${ARG#*=}"
      ;;
    --server=*)
      SET_SERVER="${ARG#*=}"
      ;;
    *)
      # Unknown option.
      echo "Unknown: ${ARG}"
      ;;
  esac
done


# Copy the configuration files.
cp `pwd`/config/${SET_CONFIG}/centos-7-x86_64.cfg .
cp `pwd`/config/${SET_CONFIG}/common.sh .
echo "Copying settings ...... DONE."

# Substitute SERVER field if user specifies it.
# Also we need to use double quotes so that
# the variable within string can be evaluated.
if [ -n "${SET_SERVER}" ]; then
  sed -i "s/^SERVER=.*/SERVER=${SET_SERVER}/g" common.sh
  echo "Setting SERVER ...... DONE."
fi

# Run the common jobs first.
source ./common.sh

# Initialize mock environment.
/usr/bin/mock -r centos-7-x86_64.cfg --rootdir `pwd`/chroot/ --init
