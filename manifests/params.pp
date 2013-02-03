class memcached::params {
  case $::osfamily {
    'Debian': {
      $package_name     = 'memcached'
      $service_name     = 'memcached'
      $dev_package_name = 'libmemcached-dev'
      $config_dir       = '/etc'
      $config_ext       = '.conf'
      $config_file      = '/etc/memcached.conf'
      $config_tmpl      = "$module_name/memcached.conf.erb"
      $user             = 'nobody'
    }
    'RedHat': {
      $package_name     = 'memcached'
      $service_name     = 'memcached'
      $config_dir       = '/etc/sysconfig'
      $config_ext       = ''
      $dev_package_name = 'libmemcached-devel'
      $config_file      = '/etc/sysconfig/memcached'
      $config_tmpl      = "$module_name/memcached_sysconfig.erb"
      $user             = 'memcached'
    }
    default: {
      fail("Unsupported platform: ${::osfamily}")
    }
  }
}
