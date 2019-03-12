# Class to prepare the Chassis box for WP core development.
class core-dev (
	$config
) {
	class { 'core-dev::repository':
		config => $config,
	}

	file { '/vagrant/wordpress-develop/src/wp-config.php':
		content => template('core-dev/wp-config.php.erb'),
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

	class { 'core-dev::build': }

	# Symlink /build and /src into the nginx root.
	# (Overrides `puppet/modules/chassis/manifests/site.pp`)
	File<|title == '/vagrant/src'|> {
		ensure => link,
		target => '/vagrant/wordpress-develop/src',
	}
	File<|title == '/vagrant/build'|> {
		ensure => link,
		target => '/vagrant/wordpress-develop/build',
	}

	# core-dev::build { 'src':
	# 	grunt_command => 'build --dev',
	# 	require       => Exec['npm install'],
	# }

	# core-dev::build { 'build':
	# 	grunt_command => 'build',
	# 	require       => Exec['npm install'],
	# }

	# core-dev::site { "${ config['hosts'][0] }/src":
	# 	sitename          => 'WordPress Develop (source)',
	# 	location          => '/vagrant/wordpress-develop/src',
	# 	database          => "${ config[database][name] }_src",
	# 	# database          => config[database][name],
	# 	database_user     => $config[database][user],
	# 	database_password => $config[database][password],
	# 	admin_user        => $config[admin][user],
	# 	admin_email       => $config[admin][email],
	# 	admin_password    => $config[admin][password],

	# 	require           => Core-dev::Build['src'],
	# }

	# core-dev::site { "${ config['hosts'][0] }/build":
	# 	sitename          => 'WordPress Develop (build)',
	# 	location          => '/vagrant/wordpress-develop/build',
	# 	database          => "${ config[database][name] }_build",
	# 	# database          => config[database][name],
	# 	database_user     => $config[database][user],
	# 	database_password => $config[database][password],
	# 	admin_user        => $config[admin][user],
	# 	admin_email       => $config[admin][email],
	# 	admin_password    => $config[admin][password],

	# 	require           => Core-dev::Build['build'],
	# }
}
