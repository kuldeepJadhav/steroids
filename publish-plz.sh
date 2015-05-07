#!/bin/sh

head -n 20 CHANGELOG.md

echo "Is changelog ok?"
read

git status

echo "Git status ok?"

read

echo ""
echo "Versioning the npm, now it's a good time to CTRL+C if you don't want to patch?"
echo "--> ^C and then run '$0 minor' unless you want a patch level version."

read

DEFAULTSEVERITY=patch
SEVERITY=${1:-$DEFAULTSEVERITY}

npm version $SEVERITY || exit 1

git push && git push --tags && npm publish ./

echo "DONE, remember that clients will check from updates.appgyver.com"
