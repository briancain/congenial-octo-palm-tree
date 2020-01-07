# define: nginx::resource::upstream
#
# This definition creates a new upstream proxy entry for NGINX
#
# Parameters:
#   [*members*]               - Array of member URIs for NGINX to connect to. Must follow valid NGINX syntax.
#                               If omitted, individual members should be defined with nginx::resource::upstream::member
#   [*ensure*]                - Enables or disables the specified location (present|absent)
#   [*upstream_cfg_append*]   - Hash of custom directives to put after other directives in upstream
#   [*upstream_cfg_prepend*]  - It expects a hash with custom directives to put before anything else inside upstream
#   [*upstream_fail_timeout*] - Set the fail_timeout for the upstream. Default is 10 seconds - As that is what Nginx does normally.
#   [*upstream_max_fails*]    - Set the max_fails for the upstream. Default is to use nginx default value which is 1.
#
# Actions:
#
# Requires:
#
# Sample Usage:
#  nginx::resource::upstream { 'proxypass':
#    ensure  => present,
#    members => [
#      'localhost:3000',
#      'localhost:3001',
#      'localhost:3002',
#    ],
#  }
#
#  Custom config example to use ip_hash, and 20 keepalive connections
#  create a hash with any extra custom config you want.
#  $my_config = {
#    'ip_hash'   => '',
#    'keepalive' => '20',
#  }
#  nginx::resource::upstream { 'proxypass':
#    ensure              => present,
#    members => [
#      'localhost:3000',
#      'localhost:3001',
#      'localhost:3002',
#    ],
#    upstream_cfg_prepend => $my_config,
#  }
define nginx::resource::upstream (
  Optional[Array] $members                  = undef,
  $members_tag                              = undef,
  Enum['present', 'absent'] $ensure         = 'present',
  Optional[Hash] $upstream_cfg_append       = undef,
  Optional[Hash] $upstream_cfg_prepend      = undef,
  $upstream_fail_timeout                    = '10s',
  $upstream_max_fails                       = undef,
  Enum['http', 'stream'] $upstream_context  = 'http',
) {

  if ! defined(Class['nginx']) {
    fail('You must include the nginx base class before using any defined resources')
  }

  $root_group = $::nginx::root_group

  $ensure_real = $ensure ? {
    'absent' => absent,
    default  => present,
  }

  $conf_dir_real = $upstream_context ? {
    'stream' => 'conf.stream.d',
    default  => 'conf.d',
  }

  $conf_dir = "${nginx::config::conf_dir}/${conf_dir_real}"

  Concat {
    owner => 'root',
    group => $root_group,
    mode  => '0644',
  }

  concat { "${nginx::conf_dir}/${conf_dir_real}/${name}-upstream.conf":
    ensure  => $ensure_real,
    notify  => Class['::nginx::service'],
    require => File[$conf_dir],
  }

  # Uses: $name, $upstream_cfg_prepend
  concat::fragment { "${name}_upstream_header":
    target  => "${nginx::conf_dir}/${conf_dir_real}/${name}-upstream.conf",
    order   => '10',
    content => template('nginx/upstream/upstream_header.erb'),
  }

  if $members != undef {
    # Uses: $members, $upstream_fail_timeout
    concat::fragment { "${name}_upstream_members":
      target  => "${nginx::conf_dir}/${conf_dir_real}/${name}-upstream.conf",
      order   => '50',
      content => template('nginx/upstream/upstream_members.erb'),
    }
  } else {
    # Collect exported members:
    if $members_tag {
      Nginx::Resource::Upstream::Member <<| upstream == $name and tag == $members_tag |>>
    } else {
      Nginx::Resource::Upstream::Member <<| upstream == $name |>>
    }
  }

  concat::fragment { "${name}_upstream_footer":
    target  => "${nginx::conf_dir}/${conf_dir_real}/${name}-upstream.conf",
    order   => '90',
    content => template('nginx/upstream/upstream_footer.erb'),
  }
}
