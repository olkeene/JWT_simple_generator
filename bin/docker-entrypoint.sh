#!/bin/bash

bundle check || bundle install --jobs 4 --retry 5

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

./bin/wait-for-postgres.sh

echo "Running in app: $@"
exec "$@"
