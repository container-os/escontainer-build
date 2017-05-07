#!/bin/bash

# Run the common jobs first.
source ./common.sh

# Set directory variables.
ES_TOP_DIR=`pwd`/easystack/
ES_PKG_SRC_DIR=`pwd`/easystack/pkg_src/
ES_PACKAGES_DIR=`pwd`/easystack/Packages/

# First we create necessary directories.
#   pkg_src is the location where we clone the repo.
#   Packages is the location where we place all the binary rpm files.
mkdir -p ${ES_PKG_SRC_DIR}
mkdir -p ${ES_PACKAGES_DIR}

# Clone all the necessary EasyStack packages and build rpm.
cd ${ES_PKG_SRC_DIR}
for REPO in ${REPO_ARRAY[@]}; do
  git clone git@github.com:jasonwucj/${REPO}.git
  # For each package, we call rpmgen.sh to create its rpm and source rpm.
  cd ./${REPO}/
  ./rpmgen.sh
  # Find all the binary rpm files and copy them into ES_PACKAGES_DIR directory.
  # Note that we employ "-exec" with ending "\;" to perform file copy operation.
  # See the manpage of find command for the details.
  find ./RPMS -name *.rpm -exec cp {} ${ES_PACKAGES_DIR} \;
  cd ${ES_PKG_SRC_DIR}
done

# The package sources can be removed now.
rm -rf ${ES_PKG_SRC_DIR}

# Create repodata under ES_TOP_DIR directory.
cd ${ES_TOP_DIR}
createrepo -v -o ./ ./
