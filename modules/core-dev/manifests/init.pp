# Class to prepare the Chassis box for WP core development.
class core-dev (
	$config
) {
	class { 'core-dev::repository':
		config => $config,
	}

	class { 'core-dev::build':
		require => [
			Class['core-dev::repository'],
			Class['grunt'],
			Class['npm'],
		],
	}

	core-dev::site { "${ config['hosts'][0] }/src":
		sitename          => 'WordPress Develop (source)',
		location          => '/vagrant/wordpress-develop/src',
		database          => "${ config[database][name] }_src",
		database_user     => $config[database][user],
		database_password => $config[database][password],
		admin_user        => $config[admin][user],
		admin_email       => $config[admin][email],
		admin_password    => $config[admin][password],
	}

	core-dev::site { "${ config['hosts'][0] }/build":
		sitename          => 'WordPress Develop (build)',
		location          => '/vagrant/wordpress-develop/build',
		database          => "${ config[database][name] }_build",
		database_user     => $config[database][user],
		database_password => $config[database][password],
		admin_user        => $config[admin][user],
		admin_email       => $config[admin][email],
		admin_password    => $config[admin][password],
		# Build task must complete before /build site can be registered.
		require => Class['core-dev::build'],
	}
}
