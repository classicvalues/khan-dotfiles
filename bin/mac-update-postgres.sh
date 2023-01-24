#!/bin/bash

brew install golang-migrate || echo "golang-migrate is already installed"

if brew ls postgresql@14 >/dev/null 2>&1 ; then
  echo "postgresql@14 already installed"
else
  # We do not have pg14 installed
  brew install postgresql@14
fi
brew services stop postgresql@11 || echo "postgresql@11 not running"
brew services start postgresql@14 || echo "postgresql@14 is already running"
psql --quiet -c "CREATE ROLE postgres LOGIN SUPERUSER;" postgres;
~/khan/webapp/services/progress-reports/create_databases.sh
cd ~/khan/webapp/services/progress-reports/migrations/
migrate -verbose -path .  -database 'postgres://postgres@localhost:5432/khan_dev?sslmode=disable' up