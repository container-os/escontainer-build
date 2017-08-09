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
      exit 1
      ;;
  esac
done


# Check if the directory exist and then copy configuration files.
if [ -d `pwd`/config/${SET_CONFIG} ]; then
  cp `pwd`/config/${SET_CONFIG}/escl-7-x86_64.cfg .
  cp `pwd`/config/${SET_CONFIG}/common.sh .
  cp `pwd`/config/${SET_CONFIG}/escore-packages-list .
  cp `pwd`/config/${SET_CONFIG}/escore-comps.xml .
  echo "Copying settings ...... DONE."
else
  echo "The configuration '${SET_CONFIG}' does not exist!"
  echo "Please check available configurations under ./config/ directory."
  exit 1
fi

# If the option --server= is specified, substitute SERVER field in common.sh.
# Also we need to use double quotes in sed command so that
# the variable within string can be evaluated.
if [ -n "${SET_SERVER}" ]; then
  sed -i "s/^SERVER=.*/SERVER=${SET_SERVER}/g" common.sh
  echo "Setting SERVER in common.sh ...... DONE."
fi

# Run the common jobs first.
source ./common.sh

# At this point we have variables from common.sh:
#   SERVER_OS_REPO
#   SERVER_UPDATES_REPO
# If the option --server= is specified, we need to use
# sed command to modify baseurl field in the escl-7-x86_64.cfg.
# Note that we take '#' as sed option delimiter to avoid bad effect
# of '/' characters in the variables.
if [ -n "${SET_SERVER}" ]; then
  sed -i "s#baseurl='.*os/x86_64/'#baseurl='${SERVER_OS_REPO}'#g" escl-7-x86_64.cfg
  sed -i "s#baseurl='.*updates/x86_64/'#baseurl='${SERVER_UPDATES_REPO}'#g" escl-7-x86_64.cfg
  echo "Setting SERVER in escl-7-x86_64.cfg ...... DONE."
fi

# Initialize mock environment.
/usr/bin/mock -r escl-7-x86_64.cfg --rootdir `pwd`/chroot/ --init
