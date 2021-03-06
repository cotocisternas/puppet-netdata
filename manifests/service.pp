class netdata::service inherits netdata {

  if $netdata::service_manage {

    case $::facts['service_provider'] {

      'upstart': {
        exec { 'Install init.d/upstart compatible service file':
          command => "cp /opt/netdata/${netdata::service_file} ./netdata",
          cwd     => '/etc/init.d/',
          creates => '/etc/init.d/netdata',
          before  => File['/etc/init.d/netdata'],
        }
        file { '/etc/init.d/netdata':
          ensure => present,
          owner  => 'root',
          group  => 'root',
          mode   => '0755',
        }
      }
    }

    if ! ($netdata::service_ensure in [ 'running', 'stopped' ]) {
      fail('service_ensure parameter must be running or stopped')
    }

    service { 'netdata':
      ensure     => $netdata::service_ensure,
      enable     => $netdata::service_enable,
      name       => $netdata::service_name,
      provider   => $netdata::service_provider,
      subscribe  => File['netdata_config'],
      hasstatus  => true,
      hasrestart => true,
    }
  }
}
