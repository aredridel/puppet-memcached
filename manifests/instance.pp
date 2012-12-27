define memcached::instance (
  $instance_ensure = 'present',
  $logfile         = '/var/log/memcached.log',
  $max_memory      = false,
  $lock_memory     = false,
  $listen_ip       = '0.0.0.0',
  $tcp_port        = 11211,
  $udp_port        = 11211,
  $user            = undef,
  $max_connections = '8192',
  $verbosity       = undef,
  $unix_socket     = undef
) {
  if ($user == undef) {
    $_user = $::memcached::params::user
  } else {
    $_user = $user
  }

  # Implement ensurance

  file { "${memcached::params::config_dir}/memcached_${name}${memcached::params::config_ext}":
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template($memcached::params::config_tmpl),
    require => Package[$memcached::params::package_name],
  }

  # init script creation here

  service { "memcached_${name}":
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => false,
    subscribe  => File["${memcached::params::config_dir}/memcached_${name}${memcached::params::config_ext}"],
  }
}
