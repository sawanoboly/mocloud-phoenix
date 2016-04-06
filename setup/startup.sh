#!/usr/bin/env bash

STATEFILE=/var/log/container_status
MIX_BIN=`which mix`

echo "installing" > $STATEFILE

set -e

cp -r /srv/code /srv/app
cd /srv/app


export MIX_ENV=${MIX_ENV:-"prod"}
export PORT=${PORT:-"80"}
elixir --erl "-smp enable" $MIX_BIN deps.get --force
elixir --erl "-smp enable" $MIX_BIN compile
mkdir -p priv/static
elixir --erl "-smp enable" $MIX_BIN release
if [ -f package.json ] ; then
  echo "Running npm install..."
  npm set progress=false
  npm install
  brunch build
fi
elixir --erl "-smp enable" $MIX_BIN phoenix.digest
elixir --erl "-smp enable" $MIX_BIN ecto.create
elixir --erl "-smp enable" $MIX_BIN ecto.migrate


echo "complete" > $STATEFILE
elixir --erl "-smp enable" $MIX_BIN phoenix.server
