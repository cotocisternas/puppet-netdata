class netdata::config inherits netdata {

  if $netdata::config_manage {

    notify { 'update netdata configuration': }

    validate_hash($netdata::options)
    $ini_defaults = {
      'path' => $netdata::config_file,
      'ensure' => 'present',
    }
    create_ini_settings($netdata::options, $ini_defaults)
  }
}
