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

	# Ensure SVN is installed.
	package { 'subversion':
		ensure => 'present',
	}

	# Instruct Chassis checkout to wordpress-develop folder.
	exec { 'git_exclude_exists':
		command => '/bin/false',
		unless => '/usr/bin/test -e /vagrant/.git/info/exclude',
	}

	file_line { 'ignore wordpress-develop directory':
		path => '/vagrant/.git/info/exclude',
		line => 'wordpress-develop',
		require => Exec['git_exclude_exists']
	}

	exec { 'maybe_checkout_wp_develop':
		command => '/usr/bin/git clone git://develop.git.wordpress.org/ /vagrant/wordpress-develop',
		creates => '/vagrant/wordpress-develop'
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
