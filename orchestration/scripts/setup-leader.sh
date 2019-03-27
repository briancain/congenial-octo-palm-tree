#!/bin/bash
sudo cp /vagrant/configs/server.hcl /etc/nomad.d/server.hcl

sudo systemctl enable nomad.service
sudo systemctl start nomad
sudo systemctl status nomad
