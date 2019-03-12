# Class to prepare the Chassis box for WP core development.
class core-dev (
	$config
) {
	class { 'core-dev::repository':
		config => $config,
	}

	core-dev::tests { 'prepare unit test environment':
		database          => "${ config[database][name] }_tests",
		database_user     => $config[database][user],
		database_password => $config[database][password],
		database_host     => 'localhost',
		database_prefix   => 'wptests_',
		require           => Class['core-dev::repository'],
	}

	exec { 'upgrade npm':
		command => '/usr/bin/npm install -g npm',
		user    => 'root',
		require => Class['npm'],
	}

	exec { 'npm install':
		command => '/usr/bin/npm install',
		cwd     => '/vagrant/wordpress-develop',
		user    => 'vagrant',
		require => Exec['upgrade npm'],
	}

	core-dev::build { 'src':
		grunt_command => 'build --dev',
		require       => Exec['npm install'],
	}

	core-dev::build { 'build':
		grunt_command => 'build',
		require       => Exec['npm install'],
	}

	core-dev::site { "${ config['hosts'][0] }/src":
		sitename          => 'WordPress Develop (source)',
		location          => '/vagrant/wordpress-develop/src',
		database          => "${ config[database][name] }_src",
		# database          => config[database][name],
		database_user     => $config[database][user],
		database_password => $config[database][password],
		admin_user        => $config[admin][user],
		admin_email       => $config[admin][email],
		admin_password    => $config[admin][password],

		require           => Core-dev::Build['src'],
	}

	core-dev::site { "${ config['hosts'][0] }/build":
		sitename          => 'WordPress Develop (build)',
		location          => '/vagrant/wordpress-develop/build',
		database          => "${ config[database][name] }_build",
		# database          => config[database][name],
		database_user     => $config[database][user],
		database_password => $config[database][password],
		admin_user        => $config[admin][user],
		admin_email       => $config[admin][email],
		admin_password    => $config[admin][password],

		require           => Core-dev::Build['build'],
	}
}
