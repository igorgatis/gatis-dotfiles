#!/bin/sh

set -e

if test -d /usr/local/bin -a ! -w /usr/local/bin; then
  echo "ERROR: need write permission to /usr/local/bin"
  exit 1
fi

curl -sfLO https://github.com/TheLocehiliosan/yadm/raw/master/yadm
chmod a+x ./yadm
mv ./yadm /usr/local/bin
