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

  if ($name == 'default') {
    $instance = $::memcached::params::service_name
  } else {
    $instance = "memcached-${name}"
  }

  # Implement ensurance

  file { "${memcached::params::config_dir}/${instance}${memcached::params::config_ext}":
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template($memcached::params::config_tmpl),
    require => Package[$memcached::params::package_name],
  }

  file { "/etc/init.d/${instance}":
    ensure  => 'present',
    content => template('memcached/memcached_init.redhat.erb'),
    owner   => 'root',
    mode    => '0755',
    notify  => Service["${instance}"],
  }

  service { $instance:
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => false,
    require    => [
      File["/etc/init.d/${instance}"],
      File["${memcached::params::config_dir}/${instance}${memcached::params::config_ext}"],
    ]
  }
}
