include vcsrepo

# Class to prepare the Chassis box for WP core development.
class core-dev (
	$config
) {
	# # Create vagrant-core.local
	# chassis::site { 'vagrant-core.local':
	# 	location          => '/vagrant/wordpress-develop/src',
	# 	wpdir             => '/vagrant/wordpress-develop/src',
	# 	contentdir        => '/vagrant/wordpress-develop/src/wp-content',
	# 	hosts             => ['vagrant-core.local'],
	# 	database          => 'vagrantcore_local',
	# 	database_user     => $config[database][user],
	# 	database_password => $config[database][password],
	# 	admin_user        => $config[admin][user],
	# 	admin_email       => $config[admin][email],
	# 	admin_password    => $config[admin][password],
	# 	sitename          => $config[site][name],
	# 	require => [
	# 		Class['chassis::php'],
	# 		Package['git-core'],
	# 		Class['mysql::server'],
	# 	]
	# }

	class { 'core-dev::repository':
		config => $config,
	}

	# Once the repository exists, ensure the build directory is present
	# for use as an Nginx site root.
	file { '/vagrant/wordpress-develop/build':
		ensure  => 'directory',
		require => Class['core-dev::repository'],
	}

	# package { 'php-package-name':
	# 	ensure  => $package
	# }

	# file { '/tmp/randomfile.ini':
	# 	ensure => $file,
	# 	content => '# Example content',
	# 	force  => true
	# }
}
