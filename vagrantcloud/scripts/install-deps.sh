#!/bin/bash

sudo apt-get install vim curl gnupg2 -y

curl https://cli-assets.heroku.com/install.sh | sh

echo "Installing ruby..."

curl -sSL https://rvm.io/mpapis.asc | sudo gpg2 --import -
curl -sSL https://rvm.io/pkuczynski.asc | sudo gpg2 --import -
curl -sSL https://get.rvm.io | sudo bash -s stable

source /etc/profile.d/rvm.sh
rvm requirements
rvm install 2.5.3
rvm use 2.5.3 --default

echo "Installing redis and postgresql"
sudo apt-get install redis-server postgresql libpq-dev -y

sudo systemctl start redis-server
sudo systemctl enable redis-server

sudo systemctl start postgresql
sudo systemctl enable postgresql

echo "Setting up hashicorp postgres user..."
su postgres -c "psql -c \"CREATE ROLE hashicorp WITH SUPERUSER LOGIN ENCRYPTED PASSWORD 'hashicorp';\""
