#!/bin/bash

cd /dev/vagrantcloud

bundle install
bundle exec rake db:reset
