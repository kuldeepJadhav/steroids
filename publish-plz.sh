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

git push && git push --tags

echo "DONE"
echo "- npm publish will be ran by Travis after the CI test suite passes"
echo "- please remember that clients will check for version updates from updates.appgyver.com"
