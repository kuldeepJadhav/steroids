#!/usr/bin/env bash

set -e

if command -v travis >/dev/null 2>&1; then
  echo "Setting DEVGYVER_ACCESS_TOKEN_CONTENTS in Travis from $HOME/.appgyver/devgyver.richard.token.json"
else
  echo >&2 "Script requires 'travis' to be installed. Please try: `gem install travis`.";
  exit 1;
fi

travis env set DEVGYVER_ACCESS_TOKEN_CONTENTS `cat $HOME/.appgyver/devgyver.richard.token.json` --private

echo

travis env list
