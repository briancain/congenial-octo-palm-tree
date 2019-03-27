#!/bin/bash
sudo cp /vagrant/configs/client1.hcl /etc/nomad.d/client1.hcl

sudo systemctl enable nomad.service
sudo systemctl start nomad
sudo systemctl status nomad
