#!/usr/bin/env bash

STATEFILE=/var/log/container_status
APP_NAME=${APP_NAME:-"todo"}
MIX_BIN=`which mix`

echo "installing" > $STATEFILE

set -e

cp -r /srv/code /srv/app
cd /srv/app


export MIX_ENV=${MIX_ENV:-"prod"}
export PORT=${PORT:-"80"}
ERL_OPTS="-smp enable"
elixir --erl "${ERL_OPTS}" $MIX_BIN deps.get --force
elixir --erl "${ERL_OPTS}" $MIX_BIN compile
mkdir -p priv/static
if [ -f package.json ] ; then
  echo "Running npm install..."
  npm set progress=false
  npm install
  brunch build --production
fi
elixir --erl "${ERL_OPTS}" $MIX_BIN phoenix.digest

elixir --erl "${ERL_OPTS}" $MIX_BIN release --erl="${ERL_OPTS}"
elixir --erl "${ERL_OPTS}" $MIX_BIN ecto.setup
## for SQLite
if [ -d ./db ] ; then
  ln -sf ../../db rel/todo/db
fi


echo "complete" > $STATEFILE
# elixir --erl "${ERL_OPTS}" $MIX_BIN phoenix.server
./rel/todo/bin/${APP_NAME} foreground

