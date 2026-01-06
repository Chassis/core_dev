# Class to prepare the Chassis box for WP core development.
#
# @param config Configuration hash containing database and other settings
class core_dev (
  Hash $config
) {
  class { 'core_dev::repository':
    config => $config,
  }

  class { 'core_dev::config':
    require => Class['core_dev::repository'],
  }
  class { 'core_dev::tests':
    database          => "${ config[database][name] }_tests",
    database_user     => $config[database][user],
    database_password => $config[database][password],
    database_host     => 'localhost',
    database_prefix   => 'wptests_',
    require           => Class['core_dev::repository'],
  }

  class { 'core_dev::build':
    require => Class['core_dev::config'],
  }
}
