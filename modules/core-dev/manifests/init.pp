# Class to prepare the Chassis box for WP core development.
class core-dev (
	$config
) {
	class { 'core-dev::repository':
		config => $config,
	}

	class { 'core-dev::config':
		require => Class['core-dev::repository'],
	}

	class { 'core-dev::tests':
		database          => "${ config[database][name] }_tests",
		database_user     => $config[database][user],
		database_password => $config[database][password],
		database_host     => 'localhost',
		database_prefix   => 'wptests_',
		require           => Class['core-dev::repository'],
	}

	class { 'core-dev::build':
		require => Class['core-dev::config'],
	}
}
