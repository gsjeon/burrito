#!/bin/bash

set -e

GIT_TAG="${1:-1.0.0}"

function USAGE() {
  echo "USAGE: $0 <git_tag>" 1>&2
  echo
  echo "ex) $0 1.0.0"
  echo
}

if [ $# -lt 1 ];then
  USAGE
  exit 1
fi

CURRENT_DIR=$( dirname "$(readlink -f "$0")" )
DIST_DIR=${CURRENT_DIR}/dist

curl -sLo ${CURRENT_DIR}/git-archive-all.sh \
  https://raw.githubusercontent.com/fabacab/git-archive-all.sh/master/git-archive-all.sh
chmod +x ${CURRENT_DIR}/git-archive-all.sh

git clone --recursive -b ${GIT_TAG} https://github.com/iorchard/burrito.git \
  ${DIST_DIR}/burrito
pushd ${DIST_DIR}/burrito
  ${CURRENT_DIR}/git-archive-all.sh --prefix burrito-${GIT_TAG}/ -- - | \
    gzip -9 > ${DIST_DIR}/burrito-${GIT_TAG}.tar.gz
popd
rm -fr ${DIST_DIR}/burrito
