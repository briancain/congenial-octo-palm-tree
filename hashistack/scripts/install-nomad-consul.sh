#!/bin/bash
# Packages required for nomad & consul
sudo apt-get install unzip curl vim -y

echo "Installing Nomad..."
#VERSION=$1

NOMAD_VERSION=0.8.7
cd /tmp/
curl -sSL https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip -o nomad.zip
unzip nomad.zip
sudo install nomad /usr/local/bin/nomad
sudo mkdir -p /etc/nomad.d
sudo chmod a+w /etc/nomad.d


echo "Installing Consul..."
#VERSION=$2
CONSUL_VERSION=1.4.0
curl -sSL https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip > consul.zip
unzip /tmp/consul.zip
sudo install consul /usr/bin/consul
(
cat <<-EOF
  [Unit]
  Description=consul agent
  Requires=network-online.target
  After=network-online.target

  [Service]
  Restart=on-failure
  ExecStart=/usr/bin/consul agent -dev
  ExecReload=/bin/kill -HUP $MAINPID

  [Install]
  WantedBy=multi-user.target
EOF
) | sudo tee /etc/systemd/system/consul.service
sudo systemctl enable consul.service
sudo systemctl start consul

for bin in cfssl cfssl-certinfo cfssljson
do
  echo "Installing $bin..."
  curl -sSL https://pkg.cfssl.org/R1.2/${bin}_linux-amd64 > /tmp/${bin}
  sudo install /tmp/${bin} /usr/local/bin/${bin}
done


echo "Configuring Nomad..."
nomad -autocomplete-install
complete -C /usr/local/bin/nomad nomad
sudo mkdir --parents /opt/nomad

(
cat <<-EOF
  [Unit]
  Description=Nomad
  Documentation=https://nomadproject.io/docs/
  Wants=network-online.target
  After=network-online.target

  [Service]
  ExecReload=/bin/kill -HUP $MAINPID
  ExecStart=/usr/local/bin/nomad agent -config /etc/nomad.d
  KillMode=process
  KillSignal=SIGINT
  LimitNOFILE=infinity
  LimitNPROC=infinity
  Restart=on-failure
  RestartSec=2
  StartLimitBurst=3
  StartLimitIntervalSec=10
  TasksMax=infinity

  [Install]
  WantedBy=multi-user.target
EOF
) | sudo tee /etc/systemd/system/nomad.service
sudo mkdir --parents /etc/nomad.d
sudo chmod 700 /etc/nomad.d
sudo cp /vagrant/configs/nomad.hcl /etc/nomad.d/nomad.hcl
