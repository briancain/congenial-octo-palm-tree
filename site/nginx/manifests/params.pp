# Class: nginx::params
# ====================
#
# nginx default settings and according to operating system
#
class nginx::params {
  ### Operating System Configuration
  ## This is my hacky... no hiera system. Oh well. :)
  $_module_defaults = {
    'conf_dir'    => '/etc/nginx',
    'daemon_user' => 'nginx',
    'pid'         => '/var/run/nginx.pid',
    'root_group'  => 'root',
    'log_dir'     => '/var/log/nginx',
    'log_group'   => 'root',
    'run_dir'     => '/var/nginx',
    'package_name' => 'nginx',
    'manage_repo'  => false,
  }
  case $facts['os']['family'] {
    'ArchLinux': {
      $_module_os_overrides = {
        'pid'          => false,
        'daemon_user'  => 'http',
        'log_group'    => 'log',
        'package_name' => 'nginx-mainline',
      }
    }
    'Debian': {
      if ($facts['os']['name'] == 'ubuntu' and $facts['lsbdistcodename'] in ['lucid', 'precise', 'trusty', 'xenial'])
      or ($facts['os']['name'] == 'debian' and $facts['os']['release']['major'] in ['6', '7', '8', '9']) {
        $_module_os_overrides = {
          'manage_repo' => true,
          'daemon_user' => 'www-data',
          'log_group'   => 'adm',
        }
      } else {
        $_module_os_overrides = {
          'daemon_user' => 'www-data',
          'log_group'   => 'adm',
        }
      }
    }
    'DragonFly', 'FreeBSD': {
      $_module_os_overrides = {
        'conf_dir'    => '/usr/local/etc/nginx',
        'daemon_user' => 'www',
        'root_group'  => 'wheel',
        'log_group'   => 'wheel',
      }
    }
    'Gentoo': {
      $_module_os_overrides = {
        'package_name' => 'www-servers/nginx',
      }
    }
    'RedHat': {
      if ($facts['os']['name'] in ['RedHat', 'CentOS', 'Oracle'] and $facts['os']['release']['major'] in ['6', '7']) {
        $_module_os_overrides = {
          'manage_repo' => true,
          'log_group'   => 'nginx',
        }
      } else {
        $_module_os_overrides = {
          'log_group' => 'nginx',
        }
      }
    }
    'Solaris': {
      $_module_os_overrides = {
        'daemon_user'  => 'webservd',
        'package_name' => undef,
      }
    }
    'OpenBSD': {
      $_module_os_overrides = {
        'daemon_user' => 'www',
        'root_group'  => 'wheel',
        'log_dir'     => '/var/www/logs',
        'log_group'   => 'wheel',
        'run_dir'     => '/var/www',
      }
    }
    default: {
      ## For cases not covered in $::osfamily
      case $facts['os']['name'] {
        'SmartOS': {
          $_module_os_overrides = {
            'conf_dir'    => '/usr/local/etc/nginx',
            'daemon_user' => 'www',
          }
        }
        default: { $_module_os_overrides = {} }
      }
    }
  }

  $_module_parameters = merge($_module_defaults, $_module_os_overrides)
  ### END Operating System Configuration

  ### Referenced Variables
  $conf_dir              = $_module_parameters['conf_dir']
  $log_dir               = $_module_parameters['log_dir']
  $log_group             = $_module_parameters['log_group']
  $run_dir               = $_module_parameters['run_dir']
  $temp_dir              = '/tmp'
  $pid                   = $_module_parameters['pid']

  $client_body_temp_path = "${run_dir}/client_body_temp"
  $daemon_user           = $_module_parameters['daemon_user']
  $global_owner          = 'root'
  $global_group          = $_module_parameters['root_group']
  $global_mode           = '0644'
  $http_access_log_file  = 'access.log'
  $manage_repo           = $_module_parameters['manage_repo']
  $nginx_error_log_file  = 'error.log'
  $root_group            = $_module_parameters['root_group']
  $package_name          = $_module_parameters['package_name']
  $proxy_temp_path       = "${run_dir}/proxy_temp"
  $sites_available_owner = 'root'
  $sites_available_group = $_module_parameters['root_group']
  $sites_available_mode  = '0644'
  $super_user            = true
  if fact('nginx_version') {
    # enable only for releases that are older than 1.15.0
    $add_listen_directive = versioncmp(fact('nginx_version'), '1.15.0') < 0
  } else {
    $add_listen_directive = true
  }
  ### END Referenced Variables
}
