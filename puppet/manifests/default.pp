file { '/home/vagrant/hello.txt':
  ensure => present,
}

notify{"hello test":}

class { 'nginx': }
