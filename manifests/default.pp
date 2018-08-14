file { '/home/vagrant/hello.txt':
  ensure => present,
}

class { 'nginx': }
