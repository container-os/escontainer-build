#!/bin/bash

# Run the common jobs first.
source ./common.sh

# Set variables that are going to be passed to rpmgen_mock.sh script.
MOCK_CFG=`pwd`/escl-7-x86_64.cfg
MOCK_CHROOT=`pwd`/chroot/

# Set directory variables.
ES_PKGSRC_DIR=`pwd`/easystack/pkg_src/
ES_X8664_DIR=`pwd`/easystack/x86_64/
ES_X8664_PACKAGES_DIR=`pwd`/easystack/x86_64/Packages/
ES_SOURCE_SPACKAGES_DIR=`pwd`/easystack/Source/SPackages/

# First we create necessary directories.
#   pkg_src is the location where we clone the repo.
#   Packages is the location where we place all the binary rpm files.
#   SPackages is the location where we place all the source rpm files.
mkdir -p ${ES_PKGSRC_DIR}
mkdir -p ${ES_X8664_DIR}
mkdir -p ${ES_X8664_PACKAGES_DIR}
mkdir -p ${ES_SOURCE_SPACKAGES_DIR}

# Clone all the necessary EasyStack packages and build rpm.
for REPO_ELT in ${REPO_PACKAGE_ARRAY[@]}; do
  # Pick repo element from the array one by one.
  # Each one is in the form of "INDEX:PACKAGE[/BRANCH]"
  # in which we can extract information into:
  #   IDX   <-- INDEX
  #   REPO  <-- PACKAGE[/BRANCH]

  # remove suffix after ':' character.
  IDX=${REPO_ELT%:*}
  # remove prefix before ':' character.
  REPO=${REPO_ELT#*:}

  # Then we can locate the git location with ${REPO_LOCATION_ARRAY[${IDX}]}
  # Also, we need to determine its branch if necessary.
  #
  # Example1:
  #   Assume that REPO is 'lorax'
  #   then REPO_BRANCH will be empty string
  #   and REPO will be 'lorax'
  #
  # Example2:
  #   Assume that REPO is 'lorax/test-dev'
  #   then REPO_BRANCH will be '-b test-dev'
  #   and REPO will be 'lorax'

  # by default REPO_BRANCH is null string.
  REPO_BRANCH=
  if echo ${REPO} | grep -e "/"; then
    # remove prefix before '/', so we have branch here.
    REPO_BRANCH="-b ${REPO#*/}"
    # remove suffix after '/', so only repo name is left.
    REPO=${REPO%/*}
  fi

  # Clone the package.
  echo "git clone ${REPO_LOCATION_ARRAY[${IDX}]}/${REPO}.git ${REPO_BRANCH}"
  cd ${ES_PKGSRC_DIR}
  git clone ${REPO_LOCATION_ARRAY[${IDX}]}/${REPO}.git ${REPO_BRANCH}

  # For each package, we call rpmgen_mock.sh to create its source rpm
  # and binary rpm under mock environment.
  cd ./${REPO}/
  ./rpmgen_mock.sh ${MOCK_CFG} ${MOCK_CHROOT}
  # Find all the binary rpm files and copy them into ES_X8664_PACKAGES_DIR directory.
  # Find all the source rpm files and copy them into ES_SOURCE_SPACKAGES_DIR directory.
  # Note that we employ "-exec" with ending "\;" to perform file copy operation.
  # See the manpage of find command for the details.
  find ./RPMS -name *.rpm -exec cp {} ${ES_X8664_PACKAGES_DIR} \;
  find ./SRPMS -name *.rpm -exec cp {} ${ES_SOURCE_SPACKAGES_DIR} \;
done

# Create repodata under ES_X8664_DIR directory.
cd ${ES_X8664_DIR}
createrepo -v -o ./ ./
