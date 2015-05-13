#!/usr/bin/env bash

# TODO: errors inside functions are not caught (use trap)
set -e

BASE_MODULE_NAME="base-module-structure"
BASE_MODULE_REPO="git@github.com:AppGyver/${BASE_MODULE_NAME}.git"
BASE_REMOTE_NAME="base"
MODULE_REMOTE_NAME="origin"
MODULE_REPO_URL="$2"
MODULE_DIR_NAME="$1"

function clone_base_module {
  git clone "${BASE_MODULE_REPO}" "${MODULE_DIR_NAME}"
  cd "${MODULE_DIR_NAME}"
  git remote rename origin "${BASE_REMOTE_NAME}" >/dev/null
}

function create_managed_project_structure {
  echo "Setting up repositories ..."
  git remote add origin "${MODULE_REPO_URL}" >/dev/null
  git fetch origin

  git branch -m base_master >/dev/null

  git checkout -b master
  git push -u origin master
}

function install_dependencies {
  echo "Will install dependencies, please be patient ..."
  npm install
  bower install
  cd mobile
  steroids update
}

function remove_git_from_project {
  echo "Removing git setup from project "
  rm -fr .git/
}


### MAIN

clone_base_module

if [ "${MODULE_REPO_URL}" != "" ]; then
  create_managed_project_structure
else
  remove_git_from_project
fi

install_dependencies

echo ""
echo "Module Development Harness created!"
echo ""
echo "Next: "
echo " - go to WS Admin"
echo " - cd ${MODULE_DIR_NAME}"
echo " - copypaste the 'steroids module init' command in the root of module directory."
echo " - run Steroids CLI: 'cd mobile/ && steroids connect'"
echo ""
