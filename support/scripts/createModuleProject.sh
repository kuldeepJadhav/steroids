#!/usr/bin/env bash

# TODO: errors inside functions are not caught (use trap)
set -e

BASE_MODULE_NAME="base-module-structure"
BASE_MODULE_REPO="git@github.com:AppGyver/${BASE_MODULE_NAME}.git"
BASE_REMOTE_NAME="base"
MODULE_REMOTE_NAME="origin"
MODULE_REPO_URL="$1"
MODULE_DIR_NAME="`basename -s .git $1`"

function clone_base {
  git clone "${BASE_MODULE_REPO}" "${MODULE_DIR_NAME}"
  cd "${MODULE_DIR_NAME}"
  git remote rename origin "${BASE_REMOTE_NAME}" >/dev/null
}

function clone_module {
  #echo "Will create ${MODULE_DIR_NAME}"

  echo "Setting up repositories ..."
  git remote add origin "${MODULE_REPO_URL}" >/dev/null
  git fetch origin

  git checkout origin/master >/dev/null 2>&1
  git branch -d master >/dev/null

  git checkout -b master origin/master >/dev/null
}

function setup_module {
  echo "Will install dependencies, please be patient ..."
  npm install
  bower install
  cd mobile
  steroids update
}

clone_base
clone_module
setup_module

echo ""
echo "Module Development Harness created!"
echo ""
echo "Next: "
echo " - go to WS Admin"
echo " - cd ${MODULE_DIR_NAME}"
echo " - copypaste the 'steroids module init' command in the root of module directory."
echo " - run Steroids CLI: 'cd mobile/ && steroids connect'"
echo ""
